﻿using System;
using System.Data;
using System.Data.Common;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

using RetailAnalytics.Data;

using Markdown.Data.Entity.App;
using Markdown.Common.Extensions;
using Z.EntityFramework.Plus;
using System.Linq;

namespace Markdown.Data
{
    public interface IMarkdownEfContext
    {
        // Model
        DbSet<ModelRun> ModelRuns { get; set; }

        // Scenario
        DbSet<Scenario> Scenarios { get; set; }
        DbSet<ScenarioSummary> ScenarioSummaries { get; set; }
        DbSet<ScenarioHierarchyFilter> ScenarioHierarchyFilters { get; set; }
        DbSet<ScenarioProductFilter> ScenarioProductFilters { get; set; }

        // Hierarchies
        DbSet<Hierarchy> Hierarchies { get; set; }

        // Price Ladder
        DbSet<PriceLadder> PriceLadders { get; set; }
        DbSet<PriceLadderType> PriceTypes { get; set; }
        DbSet<PriceLadderValue> PriceLadderValues { get; set; }

        // Recommendations
        DbSet<RecommendationProduct> RecommendationProducts { get; set; }
        DbSet<Recommendation> Recommendations { get; set; }
        DbSet<RecommendationProjection> RecommendationProjections { get; set; }
        DbSet<RecommendationSummary> RecommendationsSummary { get; set; }
        DbSet<RecommendationProduct> RecommendationProduct { get; set; }
        DbSet<RecommendationProductSummary> RecommendationProductSummary { get; set; }

        // Dashboard
        DbSet<Dashboard> Dashboards { get; set; }
        DbSet<DashboardWidget> DashboardWidgets { get; set; }
        DbSet<DashboardLayoutType> DashboardLayoutTypes { get; set; }

        // Widget
        DbSet<Widget> Widgets { get; set; }
        DbSet<WidgetType> WidgetTypes { get; set; }
        DbSet<WidgetInstance> WidgetInstances { get; set; }

        // File Upload
        DbSet<FileUpload> FileUploads { get; set; }
        DbSet<FileUploadType> FileUploadTypes { get; set; }
        DbSet<FileUploadScenario> FileUploadScenarios { get; set; }

        //User Roles And Permissions
        DbSet<Organisation> Organisation { get; set; }
		DbSet<Module> Module { get; set; }
        DbSet<User> User { get; set; }
		DbSet<Role> Role { get; set; }
        DbSet<Permission> Permission { get; set; }
        DbSet<UserRole> UserRole { get; set; }
        DbSet<RolePermission> RolePermission { get; set; }

        // Misc
        IDbConnection Connection { get; }

        //Totals
		DbSet<ScenarioTotals> ScenarioTotals { get; set; }

        // Db Context
        int SaveChanges();

        Task<int> SaveChangesAsync(CancellationToken cancellationToken = default(CancellationToken));
    }

    public class MarkdownEfContext : DbContext, IMarkdownEfContext
    {
        public MarkdownEfContext()
        {}

        // Model
        public virtual DbSet<ModelRun> ModelRuns { get; set; }


        public virtual DbSet<Scenario> Scenarios { get; set; }
        public virtual DbSet<ScenarioSummary> ScenarioSummaries { get; set; }
        public virtual DbSet<ScenarioHierarchyFilter> ScenarioHierarchyFilters { get; set; }
        public virtual DbSet<ScenarioProductFilter> ScenarioProductFilters { get; set; }

        // Hierarchies
        public virtual DbSet<Hierarchy> Hierarchies { get; set; }

        // Price Ladder
        public virtual DbSet<PriceLadder> PriceLadders { get; set; }
        public virtual DbSet<PriceLadderType> PriceTypes { get; set; }
        public virtual DbSet<PriceLadderValue> PriceLadderValues { get; set; }

        // Recommendations
        public virtual DbSet<RecommendationProduct> RecommendationProducts { get; set; }
        public virtual DbSet<Recommendation> Recommendations { get; set; }
        public virtual DbSet<RecommendationProjection> RecommendationProjections { get; set; }
        public virtual DbSet<RecommendationSummary> RecommendationsSummary { get; set; }
        public virtual DbSet<RecommendationProduct> RecommendationProduct { get; set; }
        public virtual DbSet<RecommendationProductSummary> RecommendationProductSummary { get; set; }

        // Dashboard
        public DbSet<Dashboard> Dashboards { get; set; }
        public DbSet<DashboardWidget> DashboardWidgets { get; set; }
        public DbSet<DashboardLayoutType> DashboardLayoutTypes { get; set; }

        // File Upload
        public DbSet<FileUpload> FileUploads { get; set; }
        public DbSet<FileUploadType> FileUploadTypes { get; set; }
        public DbSet<FileUploadScenario> FileUploadScenarios { get; set; }

        // Widget
        public virtual DbSet<Widget> Widgets { get; set; }
        public virtual DbSet<WidgetType> WidgetTypes { get; set; }
        public virtual DbSet<WidgetInstance> WidgetInstances { get; set; }

        //Totals
		public virtual DbSet<ScenarioTotals> ScenarioTotals { get; set; }

		//User Roles And Permissions
		public virtual DbSet<Organisation> Organisation { get; set; }
		public virtual DbSet<Module> Module { get; set; }
		public virtual DbSet<User> User { get; set; }
		public virtual DbSet<Role> Role { get; set; }
		public virtual DbSet<Permission> Permission { get; set; }
		public virtual DbSet<UserRole> UserRole { get; set; }
		public virtual DbSet<RolePermission> RolePermission { get; set; }

        public IDbConnection Connection => _dbConnectionProvider.Connection;

        private readonly IDbConnectionProvider _dbConnectionProvider;

		public MarkdownEfContext(IDbConnectionProvider dbConnectionProvider)
		{
			_dbConnectionProvider = dbConnectionProvider;

			ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
		}

        public MarkdownEfContext(IDbConnectionProvider dbConnectionProvider, int? organisationId)
        {
            _dbConnectionProvider = dbConnectionProvider;

            ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;

            if (organisationId.HasValue)
            {
                this.Filter<Scenario>(s => s.Where(x => x.OrganisationId == organisationId.Value));
                this.Filter<ScenarioSummary>(s => s.Where(x => x.OrganisationId == organisationId.Value));
				this.Filter<ScenarioTotals>(s => s.Where(x => x.OrganisationId == organisationId.Value));
                this.Filter<RecommendationSummary>(s => s.Where(x => x.OrganisationId == organisationId.Value));
                this.Filter<RecommendationProductSummary>(s => s.Where(x => x.ClientId == organisationId.Value));
                this.Filter<Widget>(s => s.Where(x => x.OrganisationId == organisationId.Value));
            }
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql((DbConnection)_dbConnectionProvider.Connection);

            var loggerFactory = new LoggerFactory();
            loggerFactory.AddProvider(new TraceLoggerProvider());
            optionsBuilder.UseLoggerFactory(loggerFactory);

            base.OnConfiguring(optionsBuilder);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ScenarioSummary>()
                .HasKey(x => new { x.ScenarioId });

            modelBuilder.Entity<RecommendationProduct>()
                .HasKey(x => x.RecommendationProductGuid);

            modelBuilder.Entity<Recommendation>()
                .HasKey(x => x.RecommendationGuid);

            modelBuilder.Entity<RecommendationProjection>()
                .HasKey(x => x.RecommendationProjectionGuid);

            modelBuilder.Entity<DashboardWidget>()
                .HasKey(x => new { x.DashboardId, x.WidgetInstanceId });

            modelBuilder.Entity<ScenarioTotals>()
			  .HasKey(x => new { x.ScenarioId });

            modelBuilder.Entity<UserRole>()
                        .HasKey(x => new { x.UserId, x.RoleId });

            modelBuilder.Entity<UserRole>()
                        .HasOne(x => x.User)
                        .WithMany(x => x.UserRoles)
                        .HasForeignKey(x => x.UserId);

			modelBuilder.Entity<UserRole>()
						.HasOne(x => x.Role)
						.WithMany(x => x.UserRoles)
                        .HasForeignKey(x => x.RoleId);
            
			modelBuilder.Entity<RolePermission>()
			    .HasKey(x => new { x.PermissionId, x.RoleId });

			modelBuilder.Entity<RolePermission>()
					   .HasOne(x => x.Role)
                        .WithMany(x => x.RolePermission)
                        .HasForeignKey(x => x.RoleId);

			modelBuilder.Entity<RolePermission>()
						.HasOne(x => x.Permission)
						.WithMany(x => x.RolePermission)
                        .HasForeignKey(x => x.PermissionId);

            base.OnModelCreating(modelBuilder);

            // Snakecase all mappings
            foreach (var entity in modelBuilder.Model.GetEntityTypes())
            {
                foreach (var property in entity.GetProperties())
                    property.Relational().ColumnName = property.Relational().ColumnName.ToSnakeCase();
                entity.Relational().TableName = entity.ClrType.Name.ToSnakeCase();
            }
        }

        public class TraceLogger : ILogger
        {
            private readonly string _categoryName;

            public TraceLogger(string categoryName) => this._categoryName = categoryName;

            public bool IsEnabled(LogLevel logLevel) => true;

            public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
            {
                Debug.WriteLine($"{DateTime.Now:o} {logLevel} {eventId.Id} {_categoryName}");
                Debug.WriteLine(formatter(state, exception));
            }

            public IDisposable BeginScope<TState>(TState state) => null;
        }

        public class TraceLoggerProvider : ILoggerProvider
        {
            public ILogger CreateLogger(string categoryName) => new TraceLogger(categoryName);

            public void Dispose() { }
        }
    }
}
