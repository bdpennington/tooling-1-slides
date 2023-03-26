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
  <a href="https://git.streamon.fm/brian/tooling-pkmgr-bundlers" target="_blank" alt="GitLab"
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

You can specify the engine version(s) that your package is compatible with.

Compatible versions of Node.js

```json
  "engines": {
    "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
  }
```

---

# Package Compatibility

## Semver (Semantic Versioning)

You can specify the versions of dependencies your package manager will install using [semver](https://semver.org/).

Let's look at some different ways you can define dependencies. Most package managers that manage dependencies follow this convention, but not all, or to the fullest extent.

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

# How to Choose Packages

There are a few things to consider when choosing packages/libraries to use in your project.

- Does it solve a complex problem?
- Is it well maintained?
- What are its dependencies?
- Is it well used / have a large community?
- Does it have good documentation?
- Is it well typed?
- Does it have a robust testing suite?
- How does it affect the performance of your application?

---

# When Not to Reach for a Package

Often, it's tempting to reach for a package to solve a problem, but it's important to consider if it's the right tool for the job, or if you even need it in the first place.

## Utility Libraries

Libraries like [Lodash](https://lodash.com/) and [Underscore](https://underscorejs.org/) are great for providing a set of utility functions that you can use in your code. However, more often than not, they're used as a crutch to do simple things that can be easily achieved with native code. Things like this can lead to a lot of bloat.

If you really need something from these kinds of libraries, most provide a way to install/import only the specific part you need.

For example, you can install only the `clonedeep` function from Lodash:

```json
"lodash.clonedeep": "^4.5.0",
```

instead of

```json
"lodash": "^4.5.0",
```

---

# Real Example of Completely Unnecessary Bloat

In the Content Cloud frontend application, a developer installed the Bootstrap icon component library, which is a whopping 1.5MB of icons, just to use the icon component five times in the entire project.

Why is this a problem?

Well, first, it adds 1.5MB to the main bundle when a user loads the application. That's a lot. Ideally, the **entire** bundle should less than 500KB. Just from the Bootstrap icon package, the bundle is already 3x larger than it should be. The icon package was also not tree-shakable, as it was a Vue plugin.

Second, the codebase already has several other means of displaying icons, including the Material Icons font, the Font Awesome font, and the futuri-ui-kit icons (all of which are lazy-loaded and don't impact the initial bundle size).

---

# Another Example of Nondiscriminating Package Usage

Again, in the Content Cloud library, a developer needed to render a chart for one of the views. However, instead of looking for the right tool for the job, they picked the first thing that looked like it might work. It had some problems.

It was not well maintained. Looking through the packages issues on GitHub, the maintainer of the package had frequently gone months without addressing issues and often left the comment, "Sorry it took so long to get to this."

Next, and more importantly, the package listed all its production dependencies as peer dependencies. This means that when we install the package, we have to install all those peer dependencies ourselves.

Additionally, because of that, we were limited to the versions of those dependencies that the package listed as compatible.

The worst of which was limiting us to an extremely outdated version of axios. `"axios": "^0.27.2"`.

The only real solution to this was to uninstall the package entirely and reimplement the entire feature.

---
layout: cover
background: https://source.unsplash.com/X1exjxxBho4/1920x1080
---

# JavaScript Bundlers

<img src="/assets/webpack-bundle.png" style="width: 100%; height: auto;">

---

# JavaScript Module Bundlers

## Popular JavaScript Bundlers

<br />

- [webpack](https://webpack.js.org/)
- [rollup](https://rollupjs.org/guide/en/)
- [esbuild](https://esbuild.github.io/)
- [parcel](https://parceljs.org/)
- [browserify](http://browserify.org/)

## What is a JavaScript Bundler?

A JavaScript bundler is a tool that takes your code and all of its dependencies and bundles them together into deployable modules (singular, or many).

<!-- We primarily use `webpack`, though I intend to move us toward `Vite` as a dev server, which generates bundles with `rollup` -->

---

# Bundler Features

Bundlers do (or can be configured to do) a lot of different transformations to your code.

- Transpile JavaScript into older versions (babel, TypeScript, corejs)
- Use pre-processors to turn CSS libraries into JS modules (Sass, Less, PostCSS)
- Transform HTML into JS modules (Pug, EJS, Handlebars)
- Transform images into JS modules (SVG, PNG, JPG, GIF)
- Inline assets (i.e. CSS -> string, or image -> data URI)
- Use framework SFC/template compilers (Vue, Svelte)
- Code-splitting
- Tree-shaking
- ...and infinitely more via plugins

<!-- reference
- `.broserlistrc`/`.tsconfig` when talking about transpilation -->

---

# Loaders / Plugins

Loaders are plugins that do transformations on your code. Webpack calls them loaders, but other bundlers tend to refer to them simply as plugins.

Let's think about how a pre-processed language like SCSS gets turned into inlined CSS within your JS bundle from the `<style lang="scss">` block of a Vue SFC (using webpack).

Several plugins come into play here (and order matters):

1. `vue-loader` - parses the Vue SFC and extracts the `<style>` block
2. `scss-loader` - processes the SCSS and turns it into CSS (via a sass compiler)
3. `css-loader` - interprets `@import` and `url()` like `import`/`require()` and will resolve them
4. `style-loader` - inject `<style>` tag into DOM

Note that this is not necessarily how it works (different loaders are used in different versions), but it's a good example of how loaders work.

**This is the basis for how all transformations work.**

<!-- Note that each one of these plugins is configurable to modify behavior -->

---

# Visualized Transformation

<div class="flex space-between">
<div class="mr-16px w-45% flex-grow-1">

## Vue SFC

```vue
<template>
  <div class="my-class">
    <p>Hello World</p>
  </div>
</template>

<script lang="ts">
export default defineComponent({ ... })
</script>

<style lang="scss" scoped>
.my-class {
  color: red;
  p {
    font-size: 2rem;
  }
}
</style>
```
</div>
<div class="w-45% flex-grow-1">

## After Transformation in DOM

```html
<style type="text/css">
  .my-class[data-v-8859cc6c] {
    color: red;
  }
  .my-class[data-v-8859cc6c] p {
    font-size: 2rem;
  }
</style>
```

- The styles are now inlined in the `<head>` of the document
- The `scoped` attribute adds a dataset attribute to the selector, preventing contamination any place else that used the `my-class` class
- Transformed SCSS into plain CSS
- Minifies the CSS (un-minified for demo purposes)

</div>
</div>

<!-- Note that all of this is done under the hood for you by the framework, but it's important to understand how this works -->

---

# Code Splitting

## What is It?

Code splitting is the process of splitting your code into multiple bundles that can be loaded on demand.

- Load only the code needed by the client
- Increases performance

## How to Do It

It's far easier than you might think. By default, bundlers will split your code into multiple bundles when you use dynamic imports instead of static imports.

<!-- - Shorter download duration
- Faster script parsing and execution by browser -->

---

# Code Splitting Example

<div class="flex space-between">
<div class="mr-16px w-45% flex-grow-1">

**In Vue Router**

`vue-router`'s `RouteConfig` has an overload for the `component` property that takes a function that returns as promise that resolves to a component. This is a dynamic import.

```ts
const AppDashboard = () => import('./views/AppDashboard.vue');
// instead of
import AppDashboard from './views/AppDashboard.vue';

const routes: RouteConfig[] = [
  {
    path: '/dashboard',
    name: 'dashboard',
    component: AppDashboard,
  },
];
```

</div>
<div class="w-45% flex-grow-1">

**Inside a Component**

You can also lazy-load components inside of another component.

```ts
const CloseButton = () => import('./CloseButton.vue');
// instead of
import CloseButton from './CloseButton.vue';

export default defineComponent({
  components: {
    CloseButton,
  },
});
```

</div>
</div>

<!-- Talk about how `import()` works -->

---

# Tree Shaking

Tree shaking is a term commonly used within a JavaScript context to describe the removal of dead code.

It relies on the import and export statements to detect if code modules are exported and imported for use between JavaScript files.

Modern bundlers use static analysis to find dead code and remove it from the bundle.

## Example

Often, when developers refactor a large part of the codebase, it's not uncommon for them feel reluctant about deleting old versions of files in case a rollback is needed.

While this is a bad practice (we use `git` for a reason), and MRs should never be accepted without having been cleaned up, tree shaking can save us here by removing these unused files from the bundle.

---

# ESM (EcmaScript Modules) vs CommonJS/UMD Modules

ES6 (EcmaScript 2015) introduced a formalized module system for JavaScript, called ESM (EcmaScript Modules).

Prior to that, JavaScript had no formal module system, and code was bundled as CommonJS modules, or UMD (Universal Module Definition). These were intended to be used with node applications rather than in the browser -- but it was common to see them used there.

## The Big Difference

The biggest difference between ESM and other module systems is that ESM is statically analyzable, while the others are not -- they use dynamic switching routines to determine what to load at runtime.

This means that any code that was written as part of a CJS or UMD module is added into the final bundle, even if it's not used. There are ways around this, but it comes for free with ESM, making it the obvious choice.

---

# ESM vs CJS by Example

<br />

Let's look at the following CJS module:

```js
const { maxBy } = require('lodash-es');
const fns = {
  add: (a, b) => a + b,
  subtract: (a, b) => a - b,
  max: arr => maxBy(arr)
};

Object.keys(fns).forEach(fnName => module.exports[fnName] = fns[fnName]);
```

After we build our bundle, we can see that the entire `lodash-es` library is included in the bundle, even if we only use the `add` function.

```bash
$ cd dist && ls -lah
625K Apr 13 13:04 out.js
```

<!-- 
Notice that the bundle is 625KB. If we look into the output, we'll find all the functions from utils.js plus a lot of modules from lodash. Although we do not use lodash in index.js it's part of the output, which adds a lot of extra weight to our production assets.
 -->

---

# ESM vs CJS by Example

<br />

Now let's convert that to ESM:

```js
export const add = (a, b) => a + b;
export const subtract = (a, b) => a - b;

import { maxBy } from 'lodash-es';

export const max = arr => maxBy(arr);
```

After we build our bundle, we can see that it has a much smaller footprint, and only includes the functions we use (`add` in this case).

```bash
$ cd dist && ls -lah
40 Apr 13 13:04 out.js
```
Wild, right?

[More detail here](https://web.dev/commonjs-larger-bundles/)

<!-- - Note the difference in export syntax
- Mention not to copy CJS syntax from StackOverflow (i.e. `require()`)
-->
---

# Other Bundler Features

Some bundlers (like webpack) provide built-in dev servers that let you run your application locally.

Here are some of the things you can do with dev servers:

- Hot Module Replacement (HMR)
- Proxy API requests
- Intercept requests/responses
- ... and most other things any web server can do
- ... whatever else you might to implement yourself with plugins

---

# Modern Dev Servers

Recently (as of this writing in early 2023), there are some newer options for dev servers that are much faster than the traditional webpack dev server. Notably, they take full advantage of ESM, and are must faster to start up and reload after changes.

- [Vite](https://vitejs.dev/)
- [esbuild](https://esbuild.github.io/)

## Migrating from Webpack to Vite/Rollup

In the near future, I'll be migrating our webpack-based projects to Vite. Little will change in the way you interact with the dev server, other than perhaps the command used to start it.

Note that Vite itself is _not_ a bundler, but rather a tool that serves primarily as a dev server, but also can be used to bundle code. It uses `rollup` under the hood for this purpose (and maybe `esbuild` in the future).

Further, it should be understood that Vite is not a Vue specific tool, despite being developed by the Vue team. It can be used with any framework (or no framework at all).

---

# What's Next in the Tooling Series?

Some other topics I intend to cover in additional installments of this series are:

- Linters / Formatters
- Testing
- Performance
- CI/CD
- Containers (Docker)
- Container orchestration (Kubetnetes)
- Monitoring
- TypeScript (yes, it's tooling)

---

# Takeaway

<br />

In this installment, we covered the basics of package managers & bundlers, and how they work. It's important to realize that these tools, and the ones listed on the previous slide are hugely powerful, and serve to simply and improve the developer experience of writing application code.

Much of the work performed by these tools are invisible to developers, which speaks to their usability and quality.

Try to imagine what it would be like to build an application if you had to manually manage all of these things yourself (though some won't have to do any imagining).

---
layout: cover
background: https://source.unsplash.com/RCAhiGJsUUE/1920x1080
---

# Thanks!

## Questions? Comments? Ask away!

<br />
<br />

### Contact

<style>
  ul {
    list-style: none;
  }
</style>

- Slack: @bdpennington
- Email: brian.pennington@futurimedia.com