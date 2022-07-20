#!/bin/bash

cd docker-compose
`which docker-compose` up -d && cd .. || exit 4
`which ansible-playbook` ./playbook/site.yml -i ./playbook/inventory/prod.yml --vault-password-file ./passwd
cd docker-compose && docker-compose down
