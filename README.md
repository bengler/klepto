# Klepto

A gem to help fill a Trove instance with photos.

Currently only syncing from the local file system is supported, though we expect to support FTP, WebDav, and other vanilla options in the future.
Note: Do not think of this process as uploading from a directory, but syncing a whole archive.

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

`sync` performs an upload of the missing photos, and deletes any photos that are on the server but that do not exist at the source path.

For details about the options

    klepto help sync

If a project has multiple archives, then these cannot at the current time be specified in the config file. Therefore, each call to sync would require that the `--archive` option be passed to the script.

    klepto sync --archive animals --file config.yml --environment staging
    klepto sync --archive deserts --file config.yml --environment staging

You can specifically have the script stop and ask for confirmation before continuing after having displayed a summary of the work to be done.

Also, sanity checks have been added in the case where the archive is empty (typo?) and also where all existing photos would be deleted (wrong source path?).

These can be bypassed by passing the `--quiet` switch. Do so at your own risk.

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

* Fix uids to match pebble standards: photo:<realm>.<archive>$hash
* Add logging facilities.
* Add options to .yml configuration, so that archive and path can be specified in the config (less room for fat-fingered errors).
* Log failures/exceptions and continue, and report summary of errors at the end of a run (if CLI).
* Add configuration option for which version of the trove api to work against (currently just uses /api/trove/v1).
