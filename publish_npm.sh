npm cache clean
echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > ~/.npmrc
npm config set registry https://registry.npmjs.org
npm config set strict-ssl true
npm config set always-auth true

cp package.json package.json.bkp
branch=`git branch | grep "*"`
#echo "branch is '${branch}'"
if [ "${branch}" != "* master" ]
then
  #echo "only works on master branch!"
  exit
fi

#echo "getting name"
NAME=`json -f package.json name`
#echo "got ${NAME}, updating name"
json -I -f package.json -e "name='@clever/${NAME}'"
#echo "updated name, updating registry"
json -I -f package.json -e "publishConfig={registry:'https://registry.npmjs.org'}"
npm publish
mv package.json.bkp package.json
