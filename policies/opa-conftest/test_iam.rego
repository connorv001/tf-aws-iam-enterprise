package main

test_wildcard_principal_denied {
    policy := {
        "resource_changes": [
            {
                "name": "bad_role",
                "type": "aws_iam_role",
                "change": {
                    "after": {
                        "assume_role_policy": "{\"Statement\": [{\"Principal\": {\"AWS\": \"*\"}, \"Effect\": \"Allow\", \"Action\": \"sts:AssumeRole\"}]}"
                    }
                }
            }
        ]
    }
    deny["IAM role 'bad_role' has a wildcard principal in its trust policy. This is forbidden."] with input as policy
}

test_missing_boundary_denied {
    policy := {
        "resource_changes": [
            {
                "name": "no_boundary_role",
                "type": "aws_iam_role",
                "change": {
                    "after": {
                        "assume_role_policy": "{}"
                    }
                }
            }
        ]
    }
    deny["IAM role 'no_boundary_role' is missing a permissions boundary. All application roles must have one."] with input as policy
}

