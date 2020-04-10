##!/bin/bash

if [ ! -d "${JENKINS_HOME}/${JOB_NAME}_helm_charts" ]; then
cp -r ${JENKINS_HOME}/helm_template ${JENKINS_HOME}/${JOB_NAME}_helm_charts
fi

rm ${JENKINS_HOME}/${JOB_NAME}_helm_charts/cicd_sample/templates/*.yaml

if [ -f "${JOB_NAME}-image.yaml" ]; then
rm ${JOB_NAME}-image.yaml
fi

sed "s/{{.Values.app.name}}/${JOB_NAME}/g" ${JENKINS_HOME}/helm_template/cicd_sample/templates/image.yaml | sed "s|{{.Values.app.image}}|${CLIENT_DOCKER_IMAGE}|g" | sed "s|{{.Values.git.url}}|${GIT_URL}|g" | sed "s/{{.Values.git.revision}}/${GIT_COMMIT}/g" >> ${JOB_NAME}-image.yaml

sed "s/{{.Values.app.label}}/app: ${JOB_NAME}/g" ${JENKINS_HOME}/helm_template/cicd_sample/templates/pod.yaml | sed "s|{{.Values.app.image}}|${CLIENT_DOCKER_IMAGE}|g" | sed "s/{{.Values.app.name}}/${JOB_NAME}/g" >> ${JENKINS_HOME}/${JOB_NAME}_helm_charts/cicd_sample/templates/${JOB_NAME}-pod.yaml

sed "s/{{.Values.app.label}}/app: ${JOB_NAME}/g" ${JENKINS_HOME}/helm_template/cicd_sample/templates/service.yaml | sed "s/{{.Values.service.name}}/${JOB_NAME}/g" >> ${JENKINS_HOME}/${JOB_NAME}_helm_charts/cicd_sample/templates/${JOB_NAME}-service.yaml

pks login -a api.pks2.haas-443.pez.pivotal.io -u pyang -p pyang -k
pks get-credentials pyang
kubectl apply -f ${JOB_NAME}-image.yaml