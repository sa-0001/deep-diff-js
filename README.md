# @sa0001/deep-diff

[NPM][https://www.npmjs.com/package/@sa0001/deep-diff]

This module makes a reliable, readable, deep diff between any two objects or arrays.

There are options to keep only the fields which are different on the right side, or to display both the left and right values for any field which is different.

## Install

```bash
npm install @sa0001/deep-diff
```

## Usage

```javascript
const deepDiff = require('@sa0001/deep-diff')

let left = {
	fieldA: 'a'
	fieldB: 'b'
	fieldC: {
		fieldD: 'd'
	}
}
let right = {
	fieldA: 'a'
	fieldB: 'B'
	fieldC: {
		fieldD: 'D'
	}
	fieldE: 'e'
}

// by default, the result is a comparison of all values
//  which are different in `left` and `right`
deepDiff(left, right)
/*
	{
		fieldB: {
			l: 'b',
			r: 'B'
		},
		fieldC: {
			fieldD: {
				l: 'd',
				r: 'D'
			}
		},
		fieldE: {
			l: undefined,
			r: 'e'
		}
	}
*/

// with option `keepRight`, the result will contain
//  all values in `right` which are different from `left`
deepDiff(left, right, { keepRight: true })
/*
	{
		fieldB: 'B',
		fieldC: {
			fieldD: 'D'
		}
	}
*/

// with option `shallow`, the diff will be at top-level
//  (but the comparison is still deep)
deepDiff(left, right, { shallow: true })
/*
	{
		fieldB: {
			l: 'b',
			r: 'B'
		},
		fieldC: {
			l: {
				fieldD: 'd'
			},
			r: {
				fieldD: 'D'
			}
		}
		fieldE: {
			l: undefined,
			r: 'e'
		}
	}
*/
```

## License

[MIT](http://vjpr.mit-license.org)
