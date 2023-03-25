---
# try also 'default' to start simple
theme: seriph
# random image from a curated Unsplash collection by Anthony
# like them? see https://unsplash.com/collections/94734566/slidev
background: https://source.unsplash.com/X1exjxxBho4/1920x1080
# apply any windi css classes to the current slide
class: 'text-center'
# https://sli.dev/custom/highlighters.html
highlighter: shiki
# show line numbers in code blocks
lineNumbers: false
# some information about the slides, markdown enabled
info: |
  ## Tooling - Part 1
  
  ### Package Managers & Bundlers

  Understanding how package managers work, how and when to use external packages, and how bundlers work to turn the hundreds or thousands of files in your project into a deployable bundle.

  Slides available [here](https://code.ldrhub.com/brian/tooling-pkmgr-bundlers)
# persist drawings in exports and build
drawings:
  persist: false
# page transition
transition: slide-left
# use UnoCSS
css: unocss
---

# Tooling - Part 1

## Package Managers & Bundlers

Understanding how package managers work, how and when to use external packages, and how bundlers work to turn the hundreds or thousands of files in your project into a deployable bundle.

Slides available [here](https://code.ldrhub.com/brian/tooling-pkmgr-bundlers)

<div class="abs-br m-6 flex gap-2">
  <a href="https://code.ldrhub.com/brian/tooling-pkmgr-bundlers" target="_blank" alt="GitLab"
    class="text-xl slidev-icon-btn opacity-50 !border-none !hover:text-white">
    <logos-gitlab />
  </a>
</div>

<!--
Talk about tooling generally -- what it does for us, how it helps us, etc.
- Package Managers & Bundlers
- Linting
- Building
- Testing
- CI/CD

Tooling also includes:
- editor extensions
- browser extensions

All about making development easier, faster, and more consistent.
-->

---
transition: fade-out
---

# Package Mangers

Package Managers are tools for automating the installation, upgrading, configuring, or removing of programs in a consistent manner.

Examples of package managers for specific languages are:

| **Language** | **Package Manager** |
| --- | --- |
| JavaScript | npm, yarn, pnpm |
| Python | pip, conda |
| Rust | cargo |
| PHP | composer |


<!--
Reference operating system package mangers:
- apt
- yum
- dpkg
- brew
-->

---
transition: slide-up
---

# Package Manager Varieties

Package managers come with a variety of features. For the most part, they manage package dependencies, but they can also do a lot more.

Some of the features that package managers can provide are:

- **Package Specification** - Package managers can provide a description of the package, including the version, author, and license, useful if you are publishing to a package registry.
- **Dependency Management** - If you install a package that depends on another package, the package manager will install the dependency for you.
- **Building** - Package managers understand how to build your projects. If a language runs via an executable, you can often configure them to build for a specified list of CPU architectures.
- **Linting** - Many come with built-in linters. This can be useful for enforcing code style and quality.
- **Publishing** - Some package managers can publish your packages to a registry.

<!-- Usually a group of smaller applications, callable via the package manager -->
---

# Package Metadata/Specification

Used to describe a package in a way that a package registry understands.

The following several slides describe the basic anatomy of a package specification for the `npm` registry.

Here's an example of the `package.json` from the `@futur/futuri-ui-kit` repo.

```json{all|2,4,10-15|3|5|6-9|all}
{
  "name": "@futuri/futuri-ui-kit",
  "version": "0.15.8",
  "description": "A custom ui-kit built with native Web Components",
  "main": "./dist/index.js",
  "private": true,
  "publishConfig": {
    "registry": "https://npm-private.futurimedia.com/"
  },
  "repository": {
    "type": "git",
    "url": "git@code.ldrhub.com:frontend/futuri-ui-kit.git"
  },
  "author": "Futuri",
  "license": "SEE LICENSE IN Proprietary",
}
```

[Specs for package.json @ npmjs.org](https://docs.npmjs.com/cli/v9/configuring-npm/package-json)

<!-- - **Private** tells npmjs.org not to publish
- **publicConfig** tells npm where to publish instead
-->

---

# Package Scripts

A collection of common scripts used to build, test, and deploy your package, among other things.

Let's look at a few, again from the ui-kit.

```json{all|2-4|5,10,14|7-9|12-13|11,15|all}
"scripts": {
    "build:dev": "env NODE_ENV=development webpack --config webpack.config.cjs && cp -r src/assets dist/assets",
    "build:prod": "env NODE_ENV=production webpack --config webpack.config.cjs && cp -r src/assets dist/assets",
    "build:watch": "env NODE_ENV=development webpack --config webpack.config.cjs --watch",
    "build:component-readme": "npx wca analyze \"src/**/*.ts\" --format markdown --outFile COMPONENTS.md",
    "clean": "rm -rf ./dist",
    "test": "echo \"Error: no test specified\" && exit 1",
    "lint": "eslint . --ext .js,.ts",
    "format": "prettier -c -w ./**/*.{js,ts}",
    "analyze": "wca analyze \"src/**/*.ts\" --format json --outFile custom-elements.json",
    "prepare": "husky install",
    "storybook": "start-storybook -p 6006",
    "build-storybook": "build-storybook",
    "publish-vscode-data": "wca analyze \"src/**/*.ts\" --format vscode --outFile dist/vscode-html-custom-data.json",
    "prepublishOnly": "npm run publish-vscode-data",
    "publishBranch": "./scripts/ci/publish-branch.sh"
  },
```

<!-- Lifecycle scripts
  - 'prepare' is run after install
    - used for husky
  - 'prepublishOnly' Runs BEFORE the package is prepared and packed, ONLY on npm publish
 -->

---

# Package Dependencies

There are various types of dependencies that you can specify in your package specification.

They are:

- **dependencies** - required for your package to run
- **devDependencies** - only required for development, such as testing or building
- **peerDependencies** - required by your package, but are not installed -- for instance, you may be exposing a specific interface that's provided by the referenced package
- **optionalDependencies** - not required, but may provide some additional opt-in utility

<br />
<br />
<br />

[Learn more](https://docs.npmjs.com/cli/v9/configuring-npm/package-json)

---

# Dependencies Example

Let's look at the dependencies for the `@futuri/futuri-ui-kit` package.

```json{all|1-3|4-6|7-|all}
  "dependencies": {
    "lit": "^2.5.0"
  },
  "optionalDependencies": {
    "focus-visible": "^5.2.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.7",
    "@storybook/addon-essentials": "^6.5.15",
    "@storybook/web-components": "^6.5.15",
    "@typescript-eslint/eslint-plugin": "^5.47.1",
    "@typescript-eslint/parser": "^5.47.1",
    "css-loader": "^6.7.3",
    "eslint": "^8.31.0",
    "eslint-plugin-lit": "^1.7.2",
    "prettier": "^2.8.1",
    "typescript": "^4.9.4",
    "web-component-analyzer": "^1.1.6",
    "webpack": "^5.75.0",
  }
```

<!-- Talk about package-lock.json
- Contains the graph of all dependencies
- Should be committed
- Can use old versions to find a previous working version
 -->

---

# Package Compatibility

## Engines

You can specify the versions of software that your package is compatible with.

Compatible versions of Node.js

```json
  "engines": {
    "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
  }
```

---

# Package Compatibility

## Semver

You can specify the versions of dependencies your package manager will install using [semver](https://semver.org/).

Let's look at some different ways you can define dependencies. Most package managers that server as dependency managers follow this convention, but not all, or to the fullest extent.

```json{all|2|3|4|5|6|7|8|9|10|all}
"dependencies": {
  "lit": "^2.5.0",
  "focus-visible": "~5.2.0",
  "@babel/core": "7.20.7",
  "@storybook/web-components": "<=6.5.15",
  "@typescript-eslint/eslint-plugin": "1.*",
  "@typescript-eslint/parser": "*",
  "css-loader": "6.7.3-alpha",
  "eslint": "8.31.0-rc.2",
  "eslint-plugin-lit": ">=1.7.2 || <2.0.0",
}
```

[Semver Cheat Sheet](https://devhints.io/semver)

<!-- - Major - incompatible API changes
- Minor - backwards compatible
- Patch - backwards compatible bug fixes
- pinned - specific version
- ^ - caret - compatible with the latest major version
- ~ - tilde - compatible with the latest minor version
- range - specific version ranges
- * - wildcard - any version
- prerelease - alpha, beta, rc
- and | or - used with ranges
 -->

---

# Choosing Packages
