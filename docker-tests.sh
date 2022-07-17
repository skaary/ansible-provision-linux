#/bin/bash

echo "Install roles"
ansible-galaxy install -r roles/requirements.yml -p ./roles

ROLES_INSTALL="$(for d in $(/bin/ls roles/); do if [ -d roles/${d} ]; then echo $d; fi; done | grep -vE '*-setup$' | sort -R)"

echo "Ansible set verbosity"
if ! set | grep '^verbose=' >/dev/null 2>&1; then
    verbose=""
else
    if [ ${verbose} = 1 ]; then
        verbose=-v
    elif [ ${verbose} = 2 ]; then
        verbose=-vv
    elif [ ${verbose} = 3 ]; then
        verbose=-vvv
    else
        verbose=""
    fi
fi

echo "Ansible set whether random order (run roles in random order)"
if ! set | grep '^random=' >/dev/null 2>&1; then
    random=\"0\"
fi

#---------- [1] Only run a specific tag ----------
if [ ${tag} != "" ]; then
    # role=\"\$( echo \"\${tag}\" | sed 's/-/_/g' )\";
    role=${tag}
    echo "# [INSTALL] (only tag)"
    # ansible-playbook -i inventory playbook.yml --limit ${MY_HOST} ${verbose} --diff -t bootstrap-system-apt-repo
    ansible-playbook -i inventory playbook.yml --limit ${MY_HOST} ${verbose} --diff -t ${tag}
# fi
else
    # ---------- [2] Install in random order ----------
    if [ ${random} = 1 ]; then
        echo "Randomized role run"
        echo "[INSTALL] Bootstrap roles"
        # if ! ansible-playbook -i inventory playbook.yml -t ubuntu_setup --limit ${MY_HOST} ${verbose} --diff; then
        #     ansible-playbook -i inventory playbook.yml -t ubuntu_setup
        # fi

        echo "[INSTALL] Pre-defined roles (randomized)"
        for r in ${ROLES_INSTALL}; do
            if ! ansible-playbook -i inventory playbook.yml -t ${r} --limit ${MY_HOST} ${verbose} --diff; then
                ansible-playbook -i inventory playbook.yml -t ${r} --limit ${MY_HOST} ${verbose} --diff
            fi
        done

        # echo "[INSTALL] Custom apt packages"
        # if ! ansible-playbook -i inventory playbook.yml -t apt --limit \${MY_HOST} \${verbose} --diff; then;
        # ansible-playbook -i inventory playbook.yml -t apt --limit \${MY_HOST} \${verbose} --diff;
        # fi

        # echo "[INSTALL] Default applications"
        # if ! ansible-playbook -i inventory playbook.yml -t xdg --limit \${MY_HOST} \${verbose} --diff; then;
        # ansible-playbook -i inventory playbook.yml -t xdg --limit \${MY_HOST} \${verbose} --diff;
        # fi
        # ---------- [3] Install in normal playbook order ----------
    else
        echo "[INSTALL] Normal playbook"
        if ! ansible-playbook -i inventory playbook.yml --limit ${MY_HOST} ${verbose} --diff; then
            ansible-playbook -i inventory playbook.yml --limit ${MY_HOST} ${verbose} --diff
        fi
    fi
    # apt list --installed | awk '{ print $1,$2,$3 }'>install1.txt
    dpkg-query --list >install1.txt

    # # ---------- Installation (full 2nd round) ----------
    echo "Full install 2nd round"
    if ! ansible-playbook -i inventory playbook.yml --limit ${MY_HOST} ${verbose} --diff; then
        ansible-playbook -i inventory playbook.yml --limit ${MY_HOST} ${verbose} --diff
    fi

    # apt list --installed | awk '{ print $1,$2,$3 }' >install2.txt
    dpkg-query --list >install2.txt

    # # ---------- Validate diff ----------
    echo "# Validate"
    diff install1.txt install2.txt
fi
