module.exports = {
  root: true,
  extends: [
    '@react-native',
    'airbnb',
    'airbnb/hooks',
    'airbnb-typescript',
    'prettier',
    "plugin:@typescript-eslint/recommended"
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: './tsconfig.json'
  },
  plugins: [
    '@typescript-eslint',
    'prettier',
    'prefer-arrow',
    'autofix',
    'unused-imports'
  ],
  settings: {
    'import/resolver': {
      node: {
        extensions: ['.js', '.jsx', '.ts', '.tsx'],
        paths: ['./']
      }
    }
  },
  env: {
    es6: true
  },
  rules: {
    "no-console": "off",
    "@typescript-eslint/lines-between-class-members": "off",
    "@typescript-eslint/no-explicit-any": "off",
    "@typescript-eslint/no-useless-constructor": "off",
    "@typescript-eslint/no-throw-literal": "off",
    'unused-imports/no-unused-vars-ts': [
      'warn',
      {
        vars: 'all',
        varsIgnorePattern: '^_',
        args: 'after-used',
        argsIgnorePattern: '^_'
      }
    ],
    'autofix/no-debugger': 'error',
    'prefer-destructuring': [
      'error',
      {
        array: false,
        object: true
      },
      {
        enforceForRenamedProperties: false
      }
    ],
    'prefer-arrow/prefer-arrow-functions': [
      "warn",
      {
        "disallowPrototype": true,
        "singleReturnOnly": false,
        "classPropertiesAllowed": false
      }
    ],
    'import/prefer-default-export': 0,
    'react/jsx-props-no-spreading': 0,
    '@typescript-eslint/no-use-before-define': [
      'error',
      { variables: false, classes: true, functions: true }
    ],
    'no-param-reassign': 0,
    'no-underscore-dangle': [
      'error',
      { allowAfterThis: true, allow: ['_id'] }
    ],
    quotes: [2, 'single', { avoidEscape: true }],
    'no-use-before-define': 0,
    'import/no-extraneous-dependencies': [
      'error',
      {
        devDependencies: [
          'storybook/**',
          'storybook/**/**/**',
          'stories/**'
        ]
      }
    ],
    'global-require': 0,
    'react/require-default-props': 'off',
    'react/prop-types': 'off',
    'react/function-component-definition': 'off',
    'react/no-unstable-nested-components': 'off',
    'react/jsx-no-useless-fragment': 'off',
    'prettier/prettier': 'off',
    'arrow-body-style': 'off',
    'no-promise-executor-return': 'off',
    '@typescript-eslint/default-param-last': 'off',
    '@typescript-eslint/naming-convention': 'off',
    '@typescript-eslint/return-await': 'off'
  }
};
