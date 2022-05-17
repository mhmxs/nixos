_find_gemfile()
{
  dir=$PWD
  while [[ "$dir" != "/" ]]; do
    if [ -f $dir/Gemfile ]; then
      echo $dir/Gemfile
      return 0
    fi
    dir=$(dirname $dir)
  done
  return 1
}

_rake_tasks()
{
  echo $(rake -T --all 2>/dev/null|grep -e '^rake'|awk {'print $2'}|sed 's/:/\:/g')
}

_rake()
{
 COMPREPLY=()
 # don't consider a ":" a wordbreak - this lets us complete on "rake foo:*"
 COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
 local cur prev
 cur="${COMP_WORDS[COMP_CWORD]}"
 prev="${COMP_WORDS[COMP_CWORD-1]}"

 # our _rake_task output is good if we're 1) in the same directory as the last
 # time we ran it or 2) we're using the same Gemfile as the last time we ran
 # it. so check for those first before we re-run "rake -T" since that's pretty
 # expensive time-wise.
 new_cwd=$PWD
 if [[ "$cur_cwd" != "$new_cwd" ||  -z "$rake_tasks" ]]; then

#    new_gemfile=$(_find_gemfile)
#    if [ $? == 1 ]; then
#      # no Gemfile found, bail
#      return 0
#    fi

#    if [ "$new_gemfile" != "$cur_gemfile" ]; then
#     cur_gemfile=$new_gemfile
    rake_tasks=$(_rake_tasks)
#   fi
 fi
 COMPREPLY=( $(compgen -W "${rake_tasks}"  -- ${cur}))
}

complete -F _rake rake
