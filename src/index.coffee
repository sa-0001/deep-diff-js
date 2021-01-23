_ =
	concat: require 'lodash/concat'
	defaults: require 'lodash/defaults'
	isEqual: require 'lodash/isEqual'
	keys: require 'lodash/keys'
	sortBy: require 'lodash/sortBy'
	uniq: require 'lodash/uniq'
_.pretty = require '@sa0001/pretty-print'
_.typeOf = require '@sa0001/type-of'

##======================================================================================================================

typeArray     = 'array'
typeNull      = 'null'
typeObject    = 'object'
typeUndefined = 'undefined'

self =
	
	# deep comparison of two arrays or objects
	diff: (o1, o2, opts) ->
		result = {}
		isArray = o1?isArray() || o2?.isArray()
		isDifferent = false
		
		# if o1/o2 is null, then make an empty array/object
		o1 ?= if isArray then [] else {}
		o2 ?= if isArray then [] else {}
		
		keys = _.uniq _.concat _.keys(o1), _.keys(o2)
		if !isArray then keys = _.sortBy keys
		
		for k in keys
			
			v1 = o1[k]
			v2 = o2[k]
			
			if v1 == v2
				# values are same
				continue
			
			t1 = _.typeOf v1
			t2 = _.typeOf v2
			
			if t1 != t2
				# types are different
				
				if opts.ignoreNullVsUndefined
					# ignore the case when one value is null and the other is undefined
					if t1 in [typeNull, typeUndefined] && t2 in [typeNull, typeUndefined]
						continue
				
				isDifferent = true
				
				if opts.keepRight
					result[k] = v2
				else
					result[k] = { l: v1, r: v2 }
				
				continue
			
			switch t1
				when typeArray
					continue if _.isEqual v1, v2
					
					isDifferent = true
					
					if opts.keepRight
						result[k] = v2
					else if opts.shallow
						result[k] = { l: v1, r: v2 }
					else
						_diff = self.diff v1, v2,
							ignoreNullVsUndefined: opts.ignoreNullVsUndefined
							keepRight: false
							shallow: false
							name: k
						if _diff != undefined
							result[k] = _diff
					
					continue
				
				when typeObject
					continue if _.isEqual v1, v2
					
					isDifferent = true
					
					if opts.keepRight
						result[k] = v2
					else if opts.shallow
						result[k] = { l: v1, r: v2 }
					else
						_diff = self.diff v1, v2,
							ignoreNullVsUndefined: opts.ignoreNullVsUndefined
							keepRight: false
							shallow: false
							name: k
						if _diff != undefined
							result[k] = _diff
					
					continue
				
				else
					# types are same ; values are different
					
					isDifferent = true
					
					if opts.keepRight
						result[k] = v2
					else
						result[k] = { l: v1, r: v2 }
					
					continue
		
		if !isDifferent
			return undefined
		
		# return result if it has *any* keys
		for key of result
			return result
		
		return undefined

module.exports = (o1, o2, opts = {}) ->
	_.defaults opts,
		# ignore differences between null and undefined
		ignoreNullVsUndefined: false
		# keep the right value instead of a diff object
		keepRight: false
		# also pretty-print the diff to console
		prettyPrint: false
		# make diff objects on top-level
		shallow: false
	
	result = self.diff o1, o2, opts
	
	if opts.prettyPrint
		return _.pretty result
	
	return result
