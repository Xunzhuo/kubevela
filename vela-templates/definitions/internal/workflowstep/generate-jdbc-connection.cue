import (
	"vela/op"
	"encoding/base64"
)

"generate-jdbc-connection": {
	type: "workflow-step"
	annotations: {}
	description: "Generate a JDBC connection based on Component of alibaba-rds"
}
template: {
	output: op.#Read & {
		value: {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name: parameter.name
				if parameter.namespace != _|_ {
					namespace: parameter.namespace
				}
			}
		}
	}
	dbHost:   op.#ConvertString & {bt: base64.Decode(null, output.value.data["DB_HOST"])}
	dbPort:   op.#ConvertString & {bt: base64.Decode(null, output.value.data["DB_PORT"])}
	dbName:   op.#ConvertString & {bt: base64.Decode(null, output.value.data["DB_NAME"])}
	username: op.#ConvertString & {bt: base64.Decode(null, output.value.data["DB_USER"])}
	password: op.#ConvertString & {bt: base64.Decode(null, output.value.data["DB_PASSWORD"])}

	env: [
		{name: "url", value:      "jdbc://" + dbHost.str + ":" + dbPort.str + "/" + dbName.str + "?characterEncoding=utf8&useSSL=false"},
		{name: "username", value: username.str},
		{name: "password", value: password.str},
	]

	parameter: {
		// +usage=Specify the name of the secret generated by database component
		name: string
		// +usage=Specify the namespace of the secret generated by database component
		namespace?: string
	}
}
