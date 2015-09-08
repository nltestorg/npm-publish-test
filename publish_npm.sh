npm cache clean
echo "//registry.npmjs.org/:_authToken=${npm_publish_token}" > ~/.npmrc
npm config set registry https://registry.npmjs.org
npm config set strict-ssl true
npm config set always-auth true

cp package.json package.json.bkp
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
name=`json -f package.json name`
echo "got ${name}, updating name"
json -I -f package.json -e "name='@clever/${name}'"
echo "updated name, updating registry"
json -I -f package.json -e "publishConfig={registry:'https://registry.npmjs.org'}"
npm publish
mv package.json.bkp package.json
