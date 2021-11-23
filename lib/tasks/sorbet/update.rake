# sorbet.rake
namespace :sorbet do
  namespace :update do
    desc "Update Sorbet and Sorbet Rails RBIs."
    task all: :environment do
      Bundler.with_unbundled_env do
        # Pull in community-created RBIs for popular gems, such as Faker.
        #
        # If you want to use a fork of sorbet-typed for any reason, you can set
        # SRB_SORBET_TYPED_REPO to the git URL and SRB_SORBET_TYPED_REVISION
        # to the "origin/master"-type branch reference).
        system("bundle exec srb rbi sorbet-typed")
        # We don't want to include the RBI files for these gems since they're not useful.
        puts "Removing unwanted gem definitions from sorbet-typed..."
        ["rake", "rubocop"].each do |gem|
          FileUtils.remove_dir(Rails.root.join("sorbet/rbi/sorbet-typed/lib/#{gem}"))
        end
        # Use Tapioca to generate RBIs for gems
        system("bundle exec tapioca gem")
        # Generate Sorbet Rails RBIs.
        system("bundle exec rake rails_rbi:all")
        # Generate a TODO RBI for constants Tapioca doesn't understand.
        system("bundle exec tapioca todo")
        # Run suggest-typed to increase/decrease the type level of files
        # as-necessary (for example, if types became more strict in an
        # autogenerated RBI this may cause Sorbet to downgrade the `typed:`
        # sigil for one of your files to `false`). Ensures that our code will
        # pass type checking regardless of any changes to the autogenerated
        # RBIs.
        system("bundle exec srb rbi suggest-typed")
      end
    end
  end
end
