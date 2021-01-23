#!/usr/bin/env coffee
log = console.log.bind console
tap = require '@sa0001/wrap-tap'

_ = require 'lodash'
_.pretty = require '@sa0001/pretty-print'

deepDiff = require './index'

##======================================================================================================================

simpleValues1 =
	nul: null
	bool_1: true
	bool_2: false
	num_1: 123
	num_2: 4.56
	str_1: 'abc'
	str_2: 'DEF'

simpleValues2 =
	nul: null
	bool_1: false
	bool_2: true
	num_1: 4.56
	num_2: 123
	str_1: 'DEF'
	str_2: 'abc'

leftValues =
	# left + right same
	bool: true
	num: 123
	str: 'abc'
	arr: [ 'a', 1 ]
	obj: { a: 1 }
	# left set, right null
	bool_nul: true
	num_nul: 123
	str_nul: 'abc'
	arr_nul: [ 'a', 1 ]
	obj_nul: { a: 1 }
	# left set, right undefined
	bool_und: true
	num_und: 123
	str_und: 'abc'
	arr_und: [ 'a', 1 ]
	obj_und: { a: 1 }
	# left null, right set
	nul_bool: null
	nul_num: null
	nul_str: null
	nul_arr: null
	nul_obj: null
	# left undefined, right set
	und_bool: undefined
	und_num: undefined
	und_str: undefined
	und_arr: undefined
	und_obj: undefined
	# deep array, same
	deep_arr_same: [
		0
		_.values(simpleValues1)
		_.values(simpleValues2)
	]
	# deep array, different
	deep_arr_diff: [
		0
		_.values(simpleValues1)
		_.values(simpleValues2)
	]
	# deep object, same
	deep_obj_same: {
		a: 0
		b: simpleValues1
		c: simpleValues2
	}
	# deep object, different
	deep_obj_diff: {
		a: 0
		b: simpleValues1
		c: simpleValues2
	}

rightValues =
	# left + right same
	bool: true
	num: 123
	str: 'abc'
	arr: [ 'a', 1 ]
	obj: { a: 1 }
	# left set, right null
	bool_nul: null
	num_nul: null
	str_nul: null
	arr_nul: null
	obj_nul: null
	# left set, right undefined
	bool_und: undefined
	num_und: undefined
	str_und: undefined
	arr_und: undefined
	obj_und: undefined
	# left null, right set
	nul_bool: false
	nul_num: 4.56
	nul_str: 'DEF'
	nul_arr: [ 'b', 2 ]
	nul_obj: { b: 2 }
	# left undefined, right set
	und_bool: false
	und_num: 4.56
	und_str: 'DEF'
	und_arr: [ 'b', 2 ]
	und_obj: { b: 2 }
	# deep array, same
	deep_arr_same: [
		0
		_.values(simpleValues1)
		_.values(simpleValues2)
	]
	# deep array, different
	deep_arr_diff: [
		0
		_.values(simpleValues2)
		_.values(simpleValues1)
	]
	# deep object, same
	deep_obj_same: {
		a: 0
		b: simpleValues1
		c: simpleValues2
	}
	# deep object, different
	deep_obj_diff: {
		a: 0
		b: simpleValues2
		c: simpleValues1
	}

##------------------------------------------------------------------------------

tap.test 'deep-diff', (t) ->
	
	t.test 'deep', (t) ->
		
		diff = deepDiff leftValues, rightValues
		
		t.eq _.pretty(diff), """
			{
				arr_nul: {
					l: [ "a", 1 ],
					r: null
				},
				arr_und: {
					l: [ "a", 1 ],
					r: undefined
				},
				bool_nul: { l: true, r: null },
				bool_und: { l: true, r: undefined },
				deep_arr_diff: {
					"1": {
						"1": { l: true, r: false },
						"2": { l: false, r: true },
						"3": { l: 123, r: 4.56 },
						"4": { l: 4.56, r: 123 },
						"5": { l: "abc", r: "DEF" },
						"6": { l: "DEF", r: "abc" }
					},
					"2": {
						"1": { l: false, r: true },
						"2": { l: true, r: false },
						"3": { l: 4.56, r: 123 },
						"4": { l: 123, r: 4.56 },
						"5": { l: "DEF", r: "abc" },
						"6": { l: "abc", r: "DEF" }
					}
				},
				deep_obj_diff: {
					b: {
						bool_1: { l: true, r: false },
						bool_2: { l: false, r: true },
						num_1: { l: 123, r: 4.56 },
						num_2: { l: 4.56, r: 123 },
						str_1: { l: "abc", r: "DEF" },
						str_2: { l: "DEF", r: "abc" }
					},
					c: {
						bool_1: { l: false, r: true },
						bool_2: { l: true, r: false },
						num_1: { l: 4.56, r: 123 },
						num_2: { l: 123, r: 4.56 },
						str_1: { l: "DEF", r: "abc" },
						str_2: { l: "abc", r: "DEF" }
					}
				},
				nul_arr: {
					l: null,
					r: [ "b", 2 ]
				},
				nul_bool: { l: null, r: false },
				nul_num: { l: null, r: 4.56 },
				nul_obj: {
					l: null,
					r: { b: 2 }
				},
				nul_str: { l: null, r: "DEF" },
				num_nul: { l: 123, r: null },
				num_und: { l: 123, r: undefined },
				obj_nul: {
					l: { a: 1 },
					r: null
				},
				obj_und: {
					l: { a: 1 },
					r: undefined
				},
				str_nul: { l: "abc", r: null },
				str_und: { l: "abc", r: undefined },
				und_arr: {
					l: undefined,
					r: [ "b", 2 ]
				},
				und_bool: { l: undefined, r: false },
				und_num: { l: undefined, r: 4.56 },
				und_obj: {
					l: undefined,
					r: { b: 2 }
				},
				und_str: { l: undefined, r: "DEF" }
			}
		"""
	
	t.test 'shallow', (t) ->
		
		diff = deepDiff leftValues, rightValues, { shallow: true }
		
		t.eq _.pretty(diff), """
			{
				arr_nul: {
					l: [ "a", 1 ],
					r: null
				},
				arr_und: {
					l: [ "a", 1 ],
					r: undefined
				},
				bool_nul: { l: true, r: null },
				bool_und: { l: true, r: undefined },
				deep_arr_diff: {
					l: [
						0,
						[ null, true, false, 123, 4.56, "abc", "DEF" ],
						[ null, false, true, 4.56, 123, "DEF", "abc" ]
					],
					r: [
						0,
						[ null, false, true, 4.56, 123, "DEF", "abc" ],
						[ null, true, false, 123, 4.56, "abc", "DEF" ]
					]
				},
				deep_obj_diff: {
					l: {
						a: 0,
						b: {
							nul: null,
							bool_1: true,
							bool_2: false,
							num_1: 123,
							num_2: 4.56,
							str_1: "abc",
							str_2: "DEF"
						},
						c: {
							nul: null,
							bool_1: false,
							bool_2: true,
							num_1: 4.56,
							num_2: 123,
							str_1: "DEF",
							str_2: "abc"
						}
					},
					r: { a: 0, b: '<<Recursive>>', c: '<<Recursive>>' }
				},
				nul_arr: {
					l: null,
					r: [ "b", 2 ]
				},
				nul_bool: { l: null, r: false },
				nul_num: { l: null, r: 4.56 },
				nul_obj: {
					l: null,
					r: { b: 2 }
				},
				nul_str: { l: null, r: "DEF" },
				num_nul: { l: 123, r: null },
				num_und: { l: 123, r: undefined },
				obj_nul: {
					l: { a: 1 },
					r: null
				},
				obj_und: {
					l: { a: 1 },
					r: undefined
				},
				str_nul: { l: "abc", r: null },
				str_und: { l: "abc", r: undefined },
				und_arr: {
					l: undefined,
					r: [ "b", 2 ]
				},
				und_bool: { l: undefined, r: false },
				und_num: { l: undefined, r: 4.56 },
				und_obj: {
					l: undefined,
					r: { b: 2 }
				},
				und_str: { l: undefined, r: "DEF" }
			}
		"""
	
	t.test 'ignoreNullVsUndefined', (t) ->
		
		left =
			a: true
			b: null
			c: undefined
			#d: undefined
			e:
				a: true
				b: null
				c: undefined
				#d: undefined
		
		right =
			a: false
			#b: undefined
			c: undefined
			d: null
			e:
				a: false
				#b: undefined
				c: undefined
				d: null
		
		diff = deepDiff left, right, { ignoreNullVsUndefined: true }
		
		t.eq _.pretty(diff), """
			{
				a: { l: true, r: false },
				e: {
					a: { l: true, r: false }
				}
			}
		"""
	
	t.test 'keepRight', (t) ->
		
		diff = deepDiff leftValues, rightValues, { keepRight: true }
		
		t.eq _.pretty(diff), """
			{
				arr_nul: null,
				arr_und: undefined,
				bool_nul: null,
				bool_und: undefined,
				deep_arr_diff: [
					0,
					[ null, false, true, 4.56, 123, "DEF", "abc" ],
					[ null, true, false, 123, 4.56, "abc", "DEF" ]
				],
				deep_obj_diff: {
					a: 0,
					b: {
						nul: null,
						bool_1: false,
						bool_2: true,
						num_1: 4.56,
						num_2: 123,
						str_1: "DEF",
						str_2: "abc"
					},
					c: {
						nul: null,
						bool_1: true,
						bool_2: false,
						num_1: 123,
						num_2: 4.56,
						str_1: "abc",
						str_2: "DEF"
					}
				},
				nul_arr: [ "b", 2 ],
				nul_bool: false,
				nul_num: 4.56,
				nul_obj: { b: 2 },
				nul_str: "DEF",
				num_nul: null,
				num_und: undefined,
				obj_nul: null,
				obj_und: undefined,
				str_nul: null,
				str_und: undefined,
				und_arr: [ "b", 2 ],
				und_bool: false,
				und_num: 4.56,
				und_obj: { b: 2 },
				und_str: "DEF"
			}
		"""
