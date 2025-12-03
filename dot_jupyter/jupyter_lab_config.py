# Configuration file for lab.

import os


c = get_config()  # noqa

c.LabApp.collaborative = True
c.ServerApp.allow_remote_access = True
c.ServerApp.ip = os.getenv("TS_IP")
