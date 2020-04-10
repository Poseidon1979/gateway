cd ${JENKINS_HOME}/${JOB_NAME}_helm_charts/
helm package cicd_sample

helm list | awk '{print $1}' | grep ${JOB_NAME}

if [ $? -eq 0 ]; then
helm uninstall ${JOB_NAME}
fi

helm install ${JOB_NAME} cicd_sample-0.1.0.tgz
