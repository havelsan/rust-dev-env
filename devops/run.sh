#!/bin/bash
nohup ./gitea_executable -c $GITEA_HOME/custom/conf/app.ini >& $GITEA_HOME/log/gitea.run.log &
nohup ./gitea-mcp -c $GITEA_HOME/custom/conf/app.ini >& $GITEA_HOME/log/gitea-mcp.run.log &

