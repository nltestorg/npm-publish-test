FROM google/nodejs:0.10.29

# s3cmd
RUN apt-get -y update && apt-get install -y python-dev python-pip
# Specify s3cmd v1.5.0 to allow use of env vars in .s3cfg file
RUN pip install s3cmd==1.5.0-alpha3

WORKDIR /npm-publish-test

# install before code for caching
ADD package.json /npm-publish-test/package.json
ADD .npmrc_docker /npm-publish-test/.npmrc
RUN npm install npm@2.7.0
RUN npm install --production

ADD . /npm-publish-test
