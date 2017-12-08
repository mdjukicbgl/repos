using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace Markdown.WebApi
{
	public static class ModelStateHelper
	{
        public static IEnumerable Errors(this ModelStateDictionary modelState)
		{
			if (!modelState.IsValid)
			{
				return modelState
				.Where(x => x.Value.Errors.Count > 0)
				.ToDictionary(
					kvp => kvp.Key,
					kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
				);
			}
			return null;
		}
	}
}
