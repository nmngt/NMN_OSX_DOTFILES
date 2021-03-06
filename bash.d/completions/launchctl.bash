#!/usr/bin/env bash
#
# git-flow-completion
# ===================
# 
# Bash completion support for launchctl (mostly)
# 
# 
# Installation
# ------------
# 
#  1. Install this file. Either:
# 
#     a. Place it in a `bash-completion.d` folder:
# 
#        * /etc/bash-completion.d
#        * /usr/local/etc/bash-completion.d
#        * ~/bash-completion.d
# 
#     b. Or, copy it somewhere (e.g. ~/.launchctl-completion.sh) and put the following line in
#        your .bashrc:
# 
#            source ~/.launchctl-completion.sh
# 
# 
# 
# The Fine Print
# --------------
# 
# Copyright (c) 2010 [Justin Hileman](http://justinhileman.com)
# 
# Distributed under the [MIT License](http://creativecommons.org/licenses/MIT/)
#
#nbe_msg "${icon_child} launchctl" ${BASH_SOURCE}


__launchctl_list_labels ()
{
	launchctl list | tail -n +2 | grep -v -P "0x[0-9a-fA-F]+\.(anonymous|mach_init)\." | awk '{print $3}'
}

__launchctl_list_started ()
{
	launchctl list | tail -n +2 | grep -v "^-" | grep -v -P "0x[0-9a-fA-F]+\.(anonymous|mach_init)\." | awk '{print $3}'
}

__launchctl_list_stopped ()
{
	launchctl list | tail -n +2 | grep "^-" | grep -v -P "0x[0-9a-fA-F]+\.(anonymous|mach_init)\." | awk '{print $3}'
}

_launchctl ()
{
	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local prev="${COMP_WORDS[COMP_CWORD-1]}"

	# Subcommand list
	local subcommands="load unload submit remove start stop list help"
	[[ ${COMP_CWORD} -eq 1 ]] && {
		COMPREPLY=( $(compgen -W "${subcommands}" -- ${cur}) )
		return
	}

	case "$prev" in
	remove|list)
		COMPREPLY=( $(compgen -W "$(__launchctl_list_labels)" -- ${cur}) )
		return
		;;
	start)
		COMPREPLY=( $(compgen -W "$(__launchctl_list_stopped)" -- ${cur}) )
		return
		;;
	stop)
		COMPREPLY=( $(compgen -W "$(__launchctl_list_started)" -- ${cur}) )
		return
		;;
	load|unload)
		COMPREPLU=( $(compgen -d $(pwd)) )
		return
		;;
	esac
}

complete -F _launchctl launchctl