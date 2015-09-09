#set -eu

npm cache clean
npm install json
cp package.json package.json.bkp

npm config set registry https://clever.registry.nodejitsu.com/
npm config set strict-ssl true
npm config set always-auth true

echo ${npm_drone_username} > nodejitsu_credentials
echo ${npm_drone_password} >> nodejitsu_credentials
echo ${npm_drone_email} >> nodejitsu_credentials
npm login < nodejitsu_credentials
rm nodejitsu_credentials

current_commit=`git log -1 HEAD --pretty=format:"%H"`
master_commit=`git log -1 master --pretty=format:"%H"`
git branch
echo "current_commit is '${current_commit}'"
echo "master_commit is '${master_commit}'"
if [ "${current_commit}" != ${master_commit} ]
then
  echo "only works on master branch!"
  exit
fi

echo "getting name"
name=`node node_modules/json/lib/json.js -f package.json name`
echo "got ${name}, updating name, publishing package"
if [[ $name == "@clever/"* ]]
then
  package_name=${name#$"@clever/"}
  echo "setting package name to ${package_name}"
  node node_modules/json/lib/json.js -I -f package.json -e "this.name='${package_name}'"
fi
echo "setting registry"
node node_modules/json/lib/json.js -I -f package.json -e "this.publishConfig={registry:'https://clever.registry.nodejitsu.com'}"
echo "publishing"
npm publish

mv package.json.bkp package.json
rm ~/.npmrc
npm uninstall json
