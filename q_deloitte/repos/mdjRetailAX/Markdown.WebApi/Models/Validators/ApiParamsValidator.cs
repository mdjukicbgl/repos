using System;
using FluentValidation;

namespace Markdown.WebApi.Models.Validators
{
    public class ApiParamsValidator<T>:AbstractValidator<T> where T:ApiParamsBase
    {
        public ApiParamsValidator()
        {
			RuleFor(recommendationsApiParams => recommendationsApiParams.PageIndex).GreaterThanOrEqualTo(1).WithMessage(
		    "PageIndex must be greater than or equal to 1");
			RuleFor(recommendationsApiParams => recommendationsApiParams.PageLimit).GreaterThanOrEqualTo(1).WithMessage(
				"PageLimit must be greater than or equal to 1");
        }
    }
}
