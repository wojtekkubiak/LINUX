
mutation key {
  createApiKey(input: {
    name: "tf_nc_if_api"
  }) {
    id
    secret
  }
}

mutation role {
  createRoleBinding(input: {
    kind: API_KEY
    role: ADMIN
    subject: "Paste API KEY ID here"
  }) {
    id
  }
}

### List all existing keys
query apis {
  apiKeys(input: {}) {
    results{
      id
      name
    }
  }
}

### Delete key
mutation apiDelete {
  deleteApiKey(input: {
    apiKeyId: ""
  })
}