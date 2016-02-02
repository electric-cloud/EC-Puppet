/*
   Copyright 2015 Electric Cloud, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 */

package test.java.ecplugins.puppet;

import static org.hamcrest.Matchers.equalTo;

import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.ClassRule;
import org.junit.Test;
import org.junit.rules.ErrorCollector;

public class TestProcedures {

	private static String directory = "";
	private static String puppetTestModule = "";
	private static String pythonJobId = "";
	private static String pythonResponse = "";
	private static String pythonCode = "";
	private static String resourceName = "";
	private static boolean temporaryResourcesCreated = false;

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		// Actions is a HashMap having primary key as procedure to run and
		// secondary key as property name
		Properties props = TestUtils.getProperties();
		ConfigurationsParser.configurationParser();
		TestUtils.createCommanderWorkspace(StringConstants.WORKSPACE_NAME);
		TestUtils.createCommanderResource(StringConstants.PUPPET_AGENT_RESOURCE_NAME, StringConstants.WORKSPACE_NAME,
				props.getProperty(StringConstants.PUPPET_AGENT_IP));
		TestUtils.createCommanderResource(StringConstants.PUPPET_MASTER_RESOURCE_NAME, StringConstants.WORKSPACE_NAME,
				props.getProperty(StringConstants.PUPPET_MASTER_IP));

		System.out.println("Starting unit tests");
	}

	@ClassRule
	public static ErrorCollector errorCollector = new ErrorCollector();

	@Test
	public void test() throws Exception {

		for (ProcedureNames procedures : ProcedureNames.values()) {
			JSONObject jsonObject = createJsonObject(procedures.getProcedures());
			if (jsonObject == null)
				continue;

			addActualParameters(procedures.getProcedures(), jsonObject);

			resourceRun(jsonObject);
			TestUtils.setResourceAndWorkspace(resourceName, StringConstants.WORKSPACE_NAME,
					"EC-Puppet-" + StringConstants.PLUGIN_VERSION);

			String jobId = TestUtils.callRunProcedure(jsonObject);
			String response = TestUtils.waitForJob(jobId, StringConstants.jobTimeoutMillis);
			// Add the job status to the collector.
			// All the failures will be printed displayed in the end.
			errorCollector.checkThat("Job completed with errors for " + procedures.getProcedures(), response,
					equalTo("success"));

			if (response.equals("success"))
				System.out.println(
						"JobId:" + jobId + ", Completed Unit Test Successfully for " + procedures.getProcedures());
			else if (jobId != null && !jobId.isEmpty())
				System.out.println("JobId:" + jobId + ", Unit test failed for  " + procedures.getProcedures());
		}

	}

	@AfterClass
	public static void tearDown() throws Exception {
		System.out.println("tearing down");
		// Clean temporary resources and workspaces
		JSONObject pythonJson = new JSONObject();
		pythonJson.put("projectName", "EC-Python-" + StringConstants.PYTHON_VERSION);
		pythonJson.put("procedureName", "runPython");
		JSONArray pythonActualParameterArray = new JSONArray();
		pythonCode = "import os\r\nos.system(\"rm -rf /tmp/" + puppetTestModule + ";\")";
		pythonActualParameterArray
				.put(new JSONObject().put("value", pythonCode).put("actualParameterName", "pythonCode"));
		pythonJson.put("actualParameter", pythonActualParameterArray);
		pythonJobId = TestUtils.callRunProcedure(pythonJson);
		pythonResponse = TestUtils.waitForJob(pythonJobId, StringConstants.jobTimeoutMillis);
		// Add the job status to the collector.
		// All the failures will be printed displayed in the end.
		errorCollector.checkThat("Job completed with errors", pythonResponse, equalTo("success"));
	}

	private JSONObject createJsonObject(String procedureName) throws JSONException {
		JSONObject jsonObject = new JSONObject();

		jsonObject.put("projectName", "EC-Puppet-" + StringConstants.PLUGIN_VERSION);

		if (!ConfigurationsParser.actions.containsKey(procedureName)) {
			System.out.println("Configurations not present for the test" + procedureName);
			return null;
		}
		jsonObject.put("procedureName", procedureName);
		return jsonObject;
	}

	private void addActualParameters(String procedureName, JSONObject jsonObject) throws JSONException {
		// This HashMap is populated by reading configurations.json file

		for (Map.Entry<String, HashMap<String, String>> objectCursor : ConfigurationsParser.actions.get(procedureName)
				.entrySet()) {

			// Every run will be new job
			JSONArray actualParameterArray = new JSONArray();

			for (Map.Entry<String, String> propertyCursor : objectCursor.getValue().entrySet()) {

				// Get each Run's data and iterate over it to populate
				// parameter array
				if (propertyCursor != null && !propertyCursor.getValue().isEmpty()) {

					if (propertyCursor.getKey().equals(StringConstants.RAKE_FILE_PATH)) {
						Path path = FileSystems.getDefault().getPath(propertyCursor.getValue());
						puppetTestModule = path.getParent().getFileName().toString();
						directory = path.getParent().getParent().toString();

					} else if (propertyCursor.getKey().equals(StringConstants.FILE_PATH)) {
						Path path = FileSystems.getDefault().getPath(propertyCursor.getValue());
						puppetTestModule = path.getFileName().toString();
						directory = path.getParent().toString();
					}
					actualParameterArray.put(new JSONObject().put("value", propertyCursor.getValue())
							.put("actualParameterName", propertyCursor.getKey()));
				}

			}
			jsonObject.put("actualParameter", actualParameterArray);
		}
	}

	private void resourceRun(JSONObject jsonObject) throws Exception {
		// Check job should run on puppet agent or puppet master
		if (jsonObject.getString("procedureName").equals("RunAgent")) {
			resourceName = StringConstants.PUPPET_AGENT_RESOURCE_NAME;
		} else {
			resourceName = StringConstants.PUPPET_MASTER_RESOURCE_NAME;
		}
		// Create temporary manifest which will be used in unit test
		if (!temporaryResourcesCreated && resourceName.equals(StringConstants.PUPPET_MASTER_RESOURCE_NAME)) {
			TestUtils.setResourceAndWorkspace(resourceName, StringConstants.WORKSPACE_NAME,
					"EC-Python-" + StringConstants.PYTHON_VERSION);
			JSONObject pythonJson = new JSONObject();
			pythonJson.put("projectName", "EC-Python-" + StringConstants.PYTHON_VERSION);
			pythonJson.put("procedureName", "runPython");
			JSONArray pythonActualParameterArray = new JSONArray();
			pythonCode = "import os\r\nos.system(\"cd " + directory + ";" + "puppet module generate " + puppetTestModule
					+ " --skip-interview;" + "cd " + puppetTestModule + ";" + "rspec-puppet-init;"
					+ "echo \\\"class test {\\nfile {'/foo':\\n  ensure  => present,\\n  content => 'bar'\\n}\\n}\\\"> manifests/init.pp;"
					+ "echo \\\"require 'spec_helper'\\ndescribe 'test' do\\ncontext 'with defaults for all parameters' do\\nit {should contain_class('test') }\\nend\\nit do\\nshould contain_file('/foo').with({\\n'ensure'  => 'present',\\n'content' => %r{^bar}\\n})\\nend\\nend\\\"> spec/classes/init_spec.rb\")";
			pythonActualParameterArray
					.put(new JSONObject().put("value", pythonCode).put("actualParameterName", "pythonCode"));
			pythonJson.put("actualParameter", pythonActualParameterArray);

			pythonJobId = TestUtils.callRunProcedure(pythonJson);
			pythonResponse = TestUtils.waitForJob(pythonJobId, StringConstants.jobTimeoutMillis);
			// Add the job status to the collector.
			// All the failures will be printed displayed in the end.
			errorCollector.checkThat("Job completed with errors", pythonResponse, equalTo("success"));
			temporaryResourcesCreated = true;
		}

	}
}
