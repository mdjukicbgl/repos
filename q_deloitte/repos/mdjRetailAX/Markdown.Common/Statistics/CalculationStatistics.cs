using System;
using System.Runtime.CompilerServices;
using System.Threading;
using Serilog;

namespace Markdown.Common.Statistics
{
    public interface ICalculationStatistics
    {
        long ProductCount { get; }
        long Recommendations { get; }
        long TotalProductCount { get; }
        long PricePaths { get; }
        long CalculateCount { get; }
        long CalculateTotal { get; }
        long HierarchyErrorCount { get; }
        double ElapsedSeconds { get; }
        long AddProducts(long productCount);
        long AddRecommendations(long recommedations);
        long AddTotalProductCount(long totalProductCount);
        long AddPricePaths(long pricePathCount);
        long AddHierarchyErrors(long hierarchyErrors);
        long StartCalculation();
        long FinishCalculation();
        void Start();
        void Stop();
    }

    public class CalculationStatistics : ICalculationStatistics
    {
        public long ProductCount
        {
            get => _productCount;
            private set => _productCount = value;
        }

        public long Recommendations
        {
            get => _recommendations;
            private set => _recommendations = value;
        }

        public long TotalProductCount
        {
            get => _totalProductCount;
            private set => _totalProductCount = value;
        }

        public long PricePaths
        {
            get => _pricePaths;
            private set => _pricePaths = value;
        }

        public long CalculateCount
        {
            get => _calculateCount;
            private set => _calculateCount = value;
        }

        public long CalculateTotal
        {
            get => _calculateTotal;
            private set => _calculateTotal = value;
        }

        public long HierarchyErrorCount
        {
            get => _hierarchyErrorCount;
            private set => _hierarchyErrorCount = value;
        }

        public double ElapsedSeconds => (DateTime.UtcNow - _startDateTime).TotalSeconds;

        private long _productCount;
        private long _recommendations;
        private long _totalProductCount;
        private long _pricePaths;
        private long _calculateCount;
        private long _calculateTotal;
        private long _hierarchyErrorCount;

        private readonly ILogger _logger;
        private readonly TimeSpan _interval;
        private readonly object _lock = new object();

        private Timer _timer;
        private long _lastTotalProductCount;
        private DateTime _startDateTime = DateTime.UtcNow;
        private DateTime _intervalDateTime = DateTime.UtcNow;

        public CalculationStatistics(ILogger logger = null)
        {
            _logger = logger;
            _interval = TimeSpan.FromSeconds(30);
        }

        public CalculationStatistics(ILogger logger, TimeSpan interval)
        {
            _logger = logger;
            _interval = interval;
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public long AddProducts(long productCount)
        {
            return Interlocked.Add(ref _productCount, productCount);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public long AddRecommendations(long recommedations)
        {
            return Interlocked.Add(ref _recommendations, recommedations);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public long AddTotalProductCount(long totalProductCount)
        {
            return Interlocked.Add(ref _totalProductCount, totalProductCount);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public long AddPricePaths(long pricePathCount)
        {
            return Interlocked.Add(ref _pricePaths, pricePathCount);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public long AddHierarchyErrors(long hierarchyErrors)
        {
            return Interlocked.Add(ref _hierarchyErrorCount, hierarchyErrors);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public long StartCalculation()
        {
            Interlocked.Increment(ref _calculateCount);
            return Interlocked.Increment(ref _calculateTotal);
        }

        [MethodImpl(MethodImplOptions.AggressiveInlining)]
        public long FinishCalculation()
        {
            return Interlocked.Decrement(ref _calculateCount);
        }

        public void Start()
        {
            lock (_lock)
            {
                if (_timer != null)
                {
                    _timer.Dispose();
                    _timer = null;
                }

                var now = DateTime.UtcNow;

                _timer = new Timer(_ => Log(), this, _interval, _interval);
                _startDateTime = now;
                _intervalDateTime = now;
            }
        }

        public void Stop()
        {
            lock (_lock)
            {
                Log();

                if (_timer != null)
                {
                    _timer.Dispose();
                    _timer = null;
                }

                _logger?.Information("Computed: {ProductCount} products in {Seconds:0.00}. Average of {Average:0.00} product/s", ProductCount, ElapsedSeconds, ProductCount / ElapsedSeconds);
            }
        }
        
        private void Log()
        {
            if (_intervalDateTime == null)
                throw new ArgumentNullException(nameof(_intervalDateTime));

            var totalPct = (ProductCount / (double) TotalProductCount) * 100.0;

            var now = DateTime.UtcNow;
            var elapsed = (now - _startDateTime).TotalSeconds;
            var totalRate = ProductCount / elapsed;
            var intervalRate = (ProductCount - _lastTotalProductCount) / (now - _intervalDateTime).TotalSeconds;
            
            var estimateDuration = TotalProductCount / totalRate;
            var estimateRemaining = estimateDuration - elapsed;

            _logger?.Information(
                "Rate: {Done:00.00}% @ {TotalRate:00.00}/s avg, {IntervalRate:00.00}/s ({Interval}s). Est: {Remaining:0}s ({Duration:0}s); " +
                "Calculations: {CalculateCount} ({CalculateTotal} finished)",
                totalPct, totalRate, intervalRate, _interval.TotalSeconds, estimateRemaining, estimateDuration,
                CalculateCount, CalculateTotal);

            _intervalDateTime = now;
            _lastTotalProductCount = ProductCount;
        }
    }
}