# Generate widdershins markdown for slate

### install widdershins
    npm install [-g] widdershins

### Generate markdown w/ widdershins
    node [/absolute/path/to/widdershins] [url|path to OpenApi3.0 spec]  [-o|output flag] [path/filename.md]

##### notes:
Having trouble with local node module installation. Installing globally and referencing absolute path in command line invocation of widdershins.

# new workflow

## event
Document update/commit in resource

## trigger
jenkins job via webhook

- ### jenkins job
clone document repository into workspace

- ### run terraform


- ** docs **
    - provision s3 bucket and upload docs from workspace
    - destroys/creates custom RHEL7.5 based ami_image


  - ** ami_image **
    - **base:** amazon RHEL7.5 (currently free-tier)
    - **dependencies:** custom configs and resources
    - **scripts:** install and configure more dependencies
    - **user_date:** auto run config options at start up
