# Use a imagem base oficial do Ruby
FROM ruby:3.2.2

# Instala dependências necessárias
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Define o diretório de trabalho na imagem
WORKDIR /app

# Copia o Gemfile e o Gemfile.lock para o diretório de trabalho
COPY Gemfile Gemfile.lock ./

# Instala as gems especificadas no Gemfile
RUN gem install bundler && bundle install

# Copia todo o conteúdo do projeto para o diretório de trabalho
COPY . .

# Exponha a porta que o Rails vai rodar
EXPOSE 3000

# Comando para iniciar o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
