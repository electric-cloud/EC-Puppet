#
#  Copyright 2015 Electric Cloud, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

@::gMatchers = (
  {
   id =>        "BuildFailed",
   pattern =>          q{.*Error:(.*)|.*(The\ssystem\scannot\sfind\sthe\spath\sspecified).*|.*Can't.*},
   action =>           q{&addSimpleError("BuildFailed", "Error $1");setProperty("outcome", "error" );updateSummary();},
  },  
  {
   id =>        "SyntaxError",
   pattern =>          q{.*(Syntax\serror).*},
   action =>           q{&addSimpleError("SyntaxError", "$1");setProperty("outcome", "error" );updateSummary();},
  },
  {
   id =>        "GenericError",
   pattern =>          q{.*Could\snot\s(.*)},
   action =>           q{&addSimpleError("GenericError", "Could not $1");setProperty("outcome", "error" );updateSummary();},
  },  
);

sub addSimpleError {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty ($name, $customError);
    }
}

sub updateSummary() {
    my $summary = (defined $::gProperties{"BuildFailed"}) ? $::gProperties{"BuildFailed"} . "\n" : "";
    $summary .= (defined $::gProperties{"SyntaxError"}) ? $::gProperties{"SyntaxError"} . "\n" : "";
    $summary .= (defined $::gProperties{"GenericError"}) ? $::gProperties{"GenericError"} . "\n" : "";
    $summary .= (defined $::gProperties{"results"}) ? $::gProperties{"results"} . "\n" : "";

    setProperty ("summary", $summary);
}