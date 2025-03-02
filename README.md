# Paris 2024
A [Symfony 7.1](https://symfony.com/) project, using [SymfonyUX](https://ux.symfony.com/) and running on [docker](https://www.docker.com/)
on a PHP 8.3 server.

## Starting

Before all install [just](https://github.com/casey/just)

### Requirements
- [Docker](https://www.docker.com/)

### Install
1. `make install` to install the project.
2. `make start` then go on `https://localhost/`, to see the index page.

### Install depedencies

To install yarn dependencies for example, you can run `just` following by your usual command.
- You can run `make static.run` to lint and format the project.

To install php dependencies, you can run `just composer` following by your usual command.
- You can run `just composer install` to install php dependencies.
- You can run `just composer require {vendor-to-install}` to install a custom php dependency.

## Git best practices
1. Respect [conventional commits](https://www.conventionalcommits.org/fr/v1.0.0/) for the commit messages.
2. Work on a branch named with a prefix (like your commit messages) : `docs`, `feat`, `fix`, `test`, `chore`, etc.
3. Make [atomic commits](https://www.codeheroes.fr/2021/10/25/git-pourquoi-ecrire-des-commits-atomiques/).

## App Structure
You work in the `app` folder
- the `public` folder inside `app` is the [Symfony](https://symfony.com/) build : you don't have to touch it.
- The `src` folder inside `app` is the [Symfony](https://symfony.com/) folder.
- The `templates` folder inside `app` is the [Twig](https://twig.symfony.com/) folder.
- The `config` folder inside `app` is the [Symfony](https://symfony.com/) configuration folder.

### Symfony
The application use Symfony 7.1 with [SymfonyUX](https://ux.symfony.com/).

### Assets

#### Styles
[Sass](https://sass-lang.com/) is used for styling

- with [ITCSS architecture](https://www.creativebloq.com/web-design/manage-large-css-projects-itcss-101517528) ;
- with [BEMIT naming convention](https://csswizardry.com/2015/08/bemit-taking-the-bem-naming-convention-a-step-further/) ;
- with [PostCSS](https://github.com/postcss/postcss)
- with [autoprefixer](https://www.npmjs.com/package/autoprefixer).
- with [purgecss](https://purgecss.com/) to purge your styles by inspecting HTML and JS generated files. You can add `--safelist` argument in script `postbuild:css` to prevent class purge mistakes.
- with [DSFR](https://github.com/GouvernementFR/dsfr/releases) styles included in `app/assets/styles/03-generics/_generics.dsfr.scss`

## Global : Formatter, linter, ...
1. [prettier](https://prettier.io/) is used to format files.
2. [eslint](https://eslint.org/) is used to check javascript syntax.
3. [phpstan](https://phpstan.org/) is used to check php syntax.
4. [php-cs-fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer) is used to format php files.
5. [phpunit](https://phpunit.de/) is used to test php files.

## HTML and accessibiliy
1. Think about validate your HTML semantics with [The W3C Markup Validation Service](https://validator.w3.org/).
2. If you're not sure about including a tag into another, you can check with [caninclude](https://caninclude.glitch.me/)
