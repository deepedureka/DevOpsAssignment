#!/bin/bash
declare -a arr
#commitid=`git log --oneline | head -n1 | awk '{print $1}'`
commitid='009b9e5'
pullid=`git show $commitid --oneline | awk -F# '{print $2}' | awk '{print $1}'`
#rm info.json
#curl https://api.bitbucket.org/2.0/repositories/deepkumarchaudhary/{rep}/pullrequests/$pullid -udeepak:5KzTtarUZHvPNhFaDE3M   | python -m json.tool > info.js:on
curl -u "C61605A:Chevron@02" http://bitbucketglobal.experian.local/rest/api/1.0/projects/SANDBOX/repos/approver-test/pull-requests/$pullid | jq '.' > info.json
#sleep 10s
jq --version
mergedTime=`jq '.closedDate' info1.json`
mergedTime1=`date -d @$mergedTime +'%d-%m-%y %H:%M:%S'`
prAuthorName=`jq '.author.user.displayName' info1.json`
prAuthorEmailAddress=`jq '.author.user.emailAddress' info1.json`
#reviewers=`jq '.reviewers[].user.displayName' info1.json`
arr=`jq -r '.reviewers[].user.displayName' info1.json`
reviewersEmailAddress=`jq '.reviewers[].user.emailAddress' info1.json`
prCommitMsg=`jq '.title' info1.json`
prBranchName=`jq '.fromRef.id' info1.json | cut -d "/" -f3`

for i in "${arr[*]}"
do
   printf "Reviewer name : $i\n"
done

echo "Merged Time:  $mergedTime1"
echo "Pull requester name: $prAuthorName"
echo "Pull requester Email Address: $prAuthorEmailAddress" 
#echo "Pull requester reviewer name: $reviewers "
echo "Pull requester reviewer Email Address: $reviewersEmailAddress"
echo "Pull requester commit title message: $prCommitMsg"
echo "Source branch: ${prBranchName%?}"