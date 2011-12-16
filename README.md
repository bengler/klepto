# Klepto

A gem to help fill a Trove instance with photos.

Currently only syncing from the local file system is supported, though we expect to support FTP, WebDav, and other vanilla options in the future.

## Installation

    gem install klepto

Or from source:

    git clone git@github.com:benglerpebbles/klepto.git
    cd klepto
    bundle install
    rake install

## Usage

### Configuration

You need to define the following in order to use Klepto:

    :archive
    :source_path
    :trove_api_key
    :trove_server
    :tootsie_server
    :s3_bucket

You can use a .yml file to store configurations, or add them flexibly at the time of using them.
The .yml file can either contain the options at the top level, or be namespaced by environment.

### CLI

There are two commands: `upload` and `sync`.

`upload` will simple add any photos from the source path that are not already on the server.
`sync` will upload the missing photos, as well as delete any photos that are on the server but that do not exist at the source path.

For details about the options

    klepto help upload

In the following example, the default configurations for the project are in config.yml, but as the project has multiple archives, the `--archive` option is specified on the command line.

    klepto sync --archive animals --file config.yml --environment staging --confirm
    klepto sync --archive deserts --file config.yml --environment staging --confirm

### In client code

You can send a yml file, or specify the various options as a hash, or set them in a block, or a combination of these.

    # with a config file
    Klepto.configure(:file => 'config/klepto.yml', :environment => 'development')

    # with a parameter hash
    options = {
        :archive => 'animals',
        :trove_server => 'http://trove.dev',
        # ... more options
    }
    Klepto.configure(options)

    # with a block
    Klepto.configure(options) do |c|
        c.archive 'animals'
        c.trove_server 'http://trove.dev'
        # ... more options
    end

    # combining options
    archive = 'animals'
    Klepto.configure(:archive => archive, :file => 'config/klepto.yml', :environment => 'test') do |c|
        c.s3_bucket s3_bucket_for(archive)
    end


## TODO

* Add logging facilities.
* Log failures/exceptions and continue, and report summary of errors at the end of a run (if CLI).
* Add configuration option for which version of the trove api to work against (currently just uses /api/trove/v1).
