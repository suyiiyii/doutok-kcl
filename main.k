import base
import yaml
import manifests

base.App {
    name = "myapp"
    replicas = 2
    image = "myimage"
    port = 8080
}
base.App {
    name = "myapp122"
    replicas = 2
    image = "myimage"
    port = 8080
}

envs = base.Envs {
    envs = {
        "APP_VAR": "varvalue"
        "APP_SECRET": "secretvalue"
    }
}

deploys = sum([base.appRender(a) for a in base.App.instances()], [])
print(yaml.encode(deploys))

apps_manifests = [base.envInjector(envs, deploy) for deploy in deploys]

env_manifests = [base.envSecretRender(a) for a in base.Envs.instances()]
# base.appRender(a)
manifests.yaml_stream([apps_manifests, env_manifests])
