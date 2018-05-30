{%- from tpldir + "/map.jinja" import postgres with context -%}
{%- from tpldir + "/macros.jinja" import format_kwargs with context -%}



{%- if 'pkg_repo' in postgres -%}

  {%- if postgres.use_upstream_repo == true -%}

# Add upstream repository for your distro
postgresql-repo:
  pkgrepo.managed:
    {%- if postgres.custom_repo_url == '' %}
    {{- format_kwargs(postgres.pkg_repo) }}
    {% else %}
    - humanname: {{ postgres.pkg_repo.humanname }}
    - file: {{ postgres.pkg_repo.file }}
    - name: deb {{ postgres.custom_repo_url }} {{ grains["oscodename"] }}-pgdg main {{ postgres.version }}
    - key_url: {{ postgres.custom_repo_gpgkey }}
    {% endif -%}

  {%- else -%}

# Remove the repo configuration (and GnuPG key) as requested
postgresql-repo:
  pkgrepo.absent:
    - name: {{ postgres.pkg_repo.name }}
    {%- if 'pkg_repo_keyid' in postgres %}
    - keyid: {{ postgres.pkg_repo_keyid }}
    {%- endif %}

  {%- endif -%}

{%- elif grains.os not in ('Windows', 'MacOS',) %}

postgresql-repo:
  test.show_notification:
    - text: |
        PostgreSQL does not provide package repository for {{ grains['osfinger'] }}

{%- endif %}
