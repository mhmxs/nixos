#!/usr/bin/env bash

SCM_THEME_PROMPT_PREFIX=" ${purple}"
SCM_THEME_PROMPT_SUFFIX=" ${normal}"
SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${green}✓"
SCM_GIT_SHOW_DETAILS="false"
SCM_GIT_SHOW_MINIMAL_INFO="true"

if [ -z "$NIX_STORE" ]; then
  sc=${red}
else
  sc=${green}
fi

function prompt_command() {
  PS1="${sc}\w${normal}$(scm_prompt_info)"
}

safe_append_prompt_command prompt_command
