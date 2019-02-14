# WIP
# webex-teams-notification
Concourse resource to provide a Webex Teams notification.

## Build
```
$ make docker
```

## Resource Scripts
### Check

*No op*

### In

*No op*

### Out
Send message to specified Webex Teams Room and/or Email, with the configured parameters.  Request will contain the following fields:

#### Source Configuration

| Param           |   Required    | Description  |
| :-------------: |:-------------:| :-----:|
| token           | Yes           | Token to authenticate with Webex teams server |
| email           | No            | Email address of a single recipient to receive the message |
| roomid          | Yes           | Room ID to send message to one or more recipients |


#### Parameters

| Param           |   Required    | Description  |
| :-------------: |:-------------:| :-----:|
| text            | Yes           | Detailed description of the state of the job |


## Example

```
resource_types:
- name: webex-teams-notification
  type: docker-image
  source:
    repository: ((localhost)):5000/webex-teams-notification
    tag: latest
    insecure_registries: [ "((localhost)):5000" ]
    
resources:
- name: alert
  type: webex-teams-notification
  source:
    token: ((webex-teams-token))
    email: bo'neill1@statestreet.com
    
put: alert
params:
text: |
  # Pull Request Failure
  > Failed to execute tests or tests returned an error
  
```
