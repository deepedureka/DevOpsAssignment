#!/usr/bin/env python3
import json
import logging
import os
import sys

try:
    import coloredlogs

    coloredlogs.install()
except ImportError:
    pass

try:
    from github import Github
except ImportError:
    print("Please ensure you install relevant dependencies.", file=sys.stderr)
    exit(-1)

logger = logging.getLogger('GitHubBot')

def fatal(*args, **kwargs):
    logger.fatal(*args, **kwargs)
    exit(-1)

def readConfig(configName='github'):
    configRead = {}

    for configFile in [os.path.join('/etc', configName), os.path.expanduser('~/.{}'.format(configName))]:
        if not os.path.exists(configFile):
            logger.warn('Unable to Find Config File: {}'.format(configFile))
            continue
        try:
            logger.info('Reading Config File: {}'.format(configFile))
            with open(configFile) as configStream:
                configReadNow = json.loads(configStream.read())
                configRead.update(configReadNow)
        except:
            logger.error('Unable to Read Config File: {}'.format(configFile))
            pass

    return configRead

def setLabelsOnPRs(githubConfig, user='tileCorporation', project='tile_services', addLabels=[], removeLabels=[]):
    githubToken = githubConfig.get('GitHubToken')
    if not githubToken:
        fatal('Unable to get GitHub Token.')
    githubClient = Github(githubToken)
    githubRepo = githubClient.get_repo('{}/{}'.format(user, project))
    for pullReq in githubRepo.get_pulls():
        for label in addLabels:
            pullReq.add_to_labels(githubRepo.get_label(label))
        for label in removeLabels:
            pullReq.remove_from_labels(githubRepo.get_label(label))
        logger.info('Processed: {}'.format(pullReq))

def main():
    toRemove = False
    if sys.argv and len(sys.argv) > 1 and sys.argv[1] == '--remove':
        toRemove = True
    try:
        if toRemove:
            setLabelsOnPRs(readConfig(), removeLabels=['Hold Merge']) #to Remove
        else:
            setLabelsOnPRs(readConfig(), addLabels=['Hold Merge'])    #to Add
    except Exception as exception:
        fatal(exception)

if __name__ == '__main__':
    main()