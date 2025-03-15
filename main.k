import base
import yaml
import manifests

apps = [
    base.App {
        name = "nginxxx"
        replicas = 2
        image = "library/nginx"
        port = 80
    }
    base.App {
        name = "caddyy"
        replicas = 2
        image = "library/caddy"
        port = 80
    }
]

envs = base.Envs {
    envs = {
        "APP_VAR": "varvalue"
        "APP_SECRET": "secretvalue"
    }
}

http = base.HTTPService {
    service = "nginxxx"
    domain = prefix + "nginxxx.ve.suyiiyii.top"
}

prefix = option(prefix, "str", False, "")
deploys = sum([base.appRender(a) for a in apps], [])

apps_manifests = [base.envInjector(envs, deploy) for deploy in deploys]

ingresses = [base.httpServiceRefine(http)]

env_manifests = [base.envSecretRender(a) for a in base.Envs.instances()]
# base.appRender(a)
manifests.yaml_stream([apps_manifests, env_manifests, ingresses, base.issuer])
# print(prefix)
