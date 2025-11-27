{% import_yaml "user_ssh/users.sls" as user_data %}
{% set users = user_data.users %}

{% for user in users %}

{{ user }}_user:
  user.present:
    - name: {{ user }}
    - home: /home/{{ user }}
    - shell: /bin/bash

{{ user }}_projects_dir:
  file.directory:
    - name: /home/{{ user }}/projekti
    - user: {{ user }}
    - group: {{ user }}
    - mode: 755
    - require:
      - user: {{ user }}_user

{% endfor %}
