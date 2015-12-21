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

package ecplugins.puppet;
import static org.junit.Assert.assertEquals;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.BeforeClass;
import org.junit.Test;

public class ManageCertificatesAndRequests {
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		// actions is a HashMap having primary key as procedure to run and secondary key as property name
		ConfigurationsParser.configurationParser();
        TestUtils.createCommanderWorkspace();
        TestUtils.createCommanderResource();
        TestUtils.deleteConfiguration();
        TestUtils.createConfiguration();
        TestUtils.setDefaultResourceAndWorkspace();
		System.out.println("Inside ManageCertificatesAndRequests");
	}

	@Test
	public void test() throws Exception {
		//This HashMap is populated by reading configurations.json file

		JSONObject jsonObject = new JSONObject();

		jsonObject.put("projectName", "EC-Puppet-"
				+ StringConstants.PLUGIN_VERSION);
        jsonObject.put("procedureName", "ManageCertificatesAndRequests");
        if( !ConfigurationsParser.actions.containsKey("ManageCertificatesAndRequests") )
        {
            System.out.println("Configurations not present for the test");
            return;
        }
		for (Map.Entry<String, HashMap<String, String>> objectCursor : ConfigurationsParser.actions.get("ManageCertificatesAndRequests").entrySet()) {

            // Every run will be new job
            JSONArray actualParameterArray = new JSONArray();

            for (Map.Entry<String, String> propertyCursor : objectCursor
                    .getValue().entrySet()) {
                // Get each Run's data and iterate over it to populate
                // parameter array
                
                if (propertyCursor != null
                        && !propertyCursor.getValue().isEmpty()) {
                        actualParameterArray.put(new JSONObject().put(
                                "value", propertyCursor.getValue()).put(
                                "actualParameterName",
                                propertyCursor.getKey()));
                    }
                }
                jsonObject.put("actualParameter", actualParameterArray);
                String jobId = TestUtils.callRunProcedure(jsonObject);
                String response = TestUtils.waitForJob(jobId, StringConstants.jobTimeoutMillis);
                // Check job status
                assertEquals("Job completed with errors", "success", response);

				System.out.println("JobId:" + jobId
						+ ", Completed ManageCertificatesAndRequests Unit Test Successfully for "
						+ objectCursor.getKey());
			}
		}
	}
