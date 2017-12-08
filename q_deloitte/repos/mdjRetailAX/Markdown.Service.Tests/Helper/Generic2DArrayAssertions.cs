using System;
using FluentAssertions;

namespace Markdown.Service.Tests
{
    public class Generic2DArrayAssertions<T>
    {
        // https://stackoverflow.com/questions/36535948/fluent-assertions-approximately-compare-two-2d-rectangular-arrays

        readonly T[,] _actual;

        public Generic2DArrayAssertions(T[,] actual)
        {
            _actual = actual;
        }

        public bool Equal(T[,] expected, Func<T, T, bool> func)
        {
            for (var i = 0; i < expected.Rank; i++)
                AssertionExtensions.Should((int) _actual.GetUpperBound(i)).Be(expected.GetUpperBound(i), "dimensions should match");

            for (var x = expected.GetLowerBound(0); x <= expected.GetUpperBound(0); x++)
            {
                for (var y = expected.GetLowerBound(1); y <= expected.GetUpperBound(1); y++)
                {
                    AssertionExtensions.Should((bool) func(_actual[x, y], expected[x, y]))
                        .BeTrue("'{2}' should equal '{3}' at element [{0},{1}]",
                            x, y, _actual[x, y], expected[x, y]);
                }
            }

            return true;
        }
    }
}