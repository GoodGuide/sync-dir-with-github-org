#!/bin/bash

set -euo pipefail

repos_dat_file=goodguide_repos.dat

[[ -f $repos_dat_file ]] || ./load_all_github_repos GoodGuide > "$repos_dat_file"

output_report_prefix=goodguide_repo_cleanup
markdown_report_filename="${output_report_prefix}.md"
renames_report_filename="${output_report_prefix}_renames.yml"

./goodguide_repo_cleanup_report "$repos_dat_file" "$output_report_prefix"

open "${markdown_report_filename}"

local_rename_script_filename="${output_report_prefix}_rename_local_clones.sh"

./build_local_rename_script < "${renames_report_filename}" > "${local_rename_script_filename}"

chmod +x "${local_rename_script_filename}"

unset CONFIRM
./rename_repos_on_github < "${renames_report_filename}"

echo "wrote local rename script to ./${local_rename_script_filename}"
