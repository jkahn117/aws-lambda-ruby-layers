mkdir ruby && \
  mkdir ruby/gems

docker run --rm \
           -v $PWD:/var/layer \
           -w /var/layer \
           lambci/lambda:build-ruby2.5 \
           bundle install --path=ruby/gems

mv ruby/gems/ruby/* ruby/gems/ && \
  rm -rf ruby/gems/2.5.0/cache && \
  rm -rf ruby/gems/ruby

mkdir ruby/lib && \
  cp *.rb ruby/lib

zip -r layer.zip ruby

rm -rf .bundle && \
 rm -rf ruby
