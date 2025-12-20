using apiModeloExamen.Repositories;
using apiModeloExamen.Helpers;
using apiModeloExamen.Repositories.Interfaces;
using Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddScoped<IDatabaseExecutor>(
    provider =>
    {
        var config = provider.GetRequiredService<IConfiguration>();
        return new DatabaseExecutor(config.GetConnectionString("Default") ?? "");
    }
);

// Add services to the container.
builder.Services.AddTransient<ICategoriaRepository, CategoriaRepository>();
builder.Services.AddTransient<IProductoRepository, ProductoRepository>();
builder.Services.AddTransient<IUsuarioRepository, UsuarioRepository>();
builder.Services.AddTransient<ICarritoRepository, CarritoRepository>();
builder.Services.AddTransient<IOrdenRepository, OrdenRepository>();
builder.Services.AddTransient<IPagoRepository, PagoRepository>();


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
