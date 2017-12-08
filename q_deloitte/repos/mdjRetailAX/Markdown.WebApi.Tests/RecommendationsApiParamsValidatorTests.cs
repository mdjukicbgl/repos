using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Markdown.WebApi.Models;
using Xunit;

namespace Markdown.WebApi.Tests
{
    public class RecommendationsApiParamsValidatorTests
    {
        [Fact]
        public void PageIndex_ShouldBeGreaterThanOrEqualToOne()
        {
            var recommendationsApiParams = new RecommendationsApiParams { PageIndex = -1 };
            var contextWithInvalidPageIndex = new ValidationContext(recommendationsApiParams, null, null);
            var resultsOfValidation = new List<ValidationResult>();


            var isValid = Validator.TryValidateObject(recommendationsApiParams,
                                                                       contextWithInvalidPageIndex, resultsOfValidation, true);

            Assert.False(isValid);
        }

		[Fact]
		public void PageLimit_ShouldBeGreaterThanOrEqualToOne()
		{
			var recommendationsApiParams = new RecommendationsApiParams { PageLimit = -1 };
			var contextWithInvalidPageLimt = new ValidationContext(recommendationsApiParams, null, null);
			var resultsOfValidation = new List<ValidationResult>();


			var isValid = Validator.TryValidateObject(recommendationsApiParams,
																	   contextWithInvalidPageLimt, resultsOfValidation, true);

			Assert.False(isValid);
		}
    }
}
