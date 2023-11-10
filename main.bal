import ballerina/io;
import ballerina/regex;

public function main() {
    constructPayload();
}

function constructPayload() {
    map<json> payload = {"projectName": "baltest", "totalTests": 2, "passed": 2, "failed": 0, "skipped": 0, "coveredLines": 0, "missedLines": 0, "coveragePercentage": 0.0, "moduleStatus": [{"name": "baltest", "totalTests": 2, "passed": 2, "failed": 0, "skipped": 0, "tests": [{"name": "id_80_exampleTest1", "status": "PASSED"}, {"name": "id_81_exampleTest2", "status": "PASSED"}]}], "moduleCoverage": []};

    json|error moduleStatus = payload.moduleStatus;

    if moduleStatus is json {
        if moduleStatus is json[] {
            json[] moduleStatusArray = moduleStatus;
            json|error tests = moduleStatusArray[0].tests;

            if tests is json[] {
                json[] testsArray = tests;

                foreach var item in testsArray {
                    if item is map<json> {
                        // It renames the "name" to "case_id".
                        item["case_id"] = item["name"];
                        _ = item.remove("name");

                        // It splits and gets case_id digit.
                        string caseName = item["case_id"].toString();
                        string[] parts = regex:split(caseName, "_");
                        string testcaseId = parts[1];
                        item["case_id"] = testcaseId;

                        //It converts the status to lowercase.
                        item["status"] = item["status"].toString().toLowerAscii();
                    }
                }

                json resultsJson = {
                    "results": testsArray
                };

                io:println(resultsJson);
            } else {
                io:println("Not a JSON array");
            }
        } else {
            io:println("Not a JSON array");
        }
    }

}
