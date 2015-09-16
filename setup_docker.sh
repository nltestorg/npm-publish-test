nodejitsu_auth=`echo -n ${npmdeployusername}:${npmdeploypassword} | base64`
sed -i.bak s/\${NODEJITSU_AUTH}/$nodejitsu_auth/ .npmrc_docker
sed -i.bak s/\${npm_auth_token}/$npm_auth_token/ .npmrc_docker
