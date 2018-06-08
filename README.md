# Rails 5.1 Postgres Active Record Deep Dive
--


### About:
Investigation into the relationship between Postgres and ActiveRecord.  A deep dive to highlight how they complement, where they diverge, and where they confound in a Rails project.

### Init Project
To set up the project, clone the repository, run the make file, and verify tables created 

    git clone https://github.com/trendwithin/pg_ar_deep_dive.git**
    rails db create
    rails db migrate
    make clean --directory db/make_files/ && make --directory db/make_files/
    rails dbconsole
    \dt+
