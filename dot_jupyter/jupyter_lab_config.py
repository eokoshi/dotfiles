# Configuration file for lab.


c = get_config()  # noqa

c.LabApp.collaborative = True
c.ServerApp.allow_remote_access = True
c.ServerApp.ip = "133.45.146.24"
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.IdentityProfider.hashed_password = "argon2:$argon2id$v=19$m=10240,t=10,p=8$KDlKrpFa1+W/jut4EYfhQQ$SaMOqdyny6ecmJEJDG+bBe5HaEGkGJo2uDXD4szZYmU"
