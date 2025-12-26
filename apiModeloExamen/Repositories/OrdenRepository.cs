using apiModeloExamen.Contracts.Entities;
using apiModeloExamen.Contracts.Dtos;
using apiModeloExamen.Repositories.Interfaces;
using Microsoft.Data.SqlClient;
using System.Data;
using Dapper;

namespace apiModeloExamen.Repositories
{
    public class OrdenRepository : IOrdenRepository
    {
        private readonly string _connectionString;
        public OrdenRepository(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("Default")!;
        }

        public async Task GenerarOrdenAsync(int idUsuario)
        {
            using var conn = new SqlConnection(_connectionString);
            await conn.ExecuteAsync(
                "sp_Orden_Generar",
                new { IdUsuario = idUsuario },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<Orden>> ListarPorUsuarioAsync(int idUsuario)
        {
            using var conn = new SqlConnection(_connectionString);
            return await conn.QueryAsync<Orden>(
                "sp_Orden_ListarPorUsuario",
                new { IdUsuario = idUsuario },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<List<PagoDetalladoDto>> ObtenerDetalleOrdenAsync(int idOrden)
        {
            using var conn = new SqlConnection(_connectionString);
            var productos = (await conn.QueryAsync<PagoDetalladoDto>(
                "sp_Orden_ObtenerDetalle",
                new { IdOrden = idOrden },
                commandType: System.Data.CommandType.StoredProcedure
            )).ToList();

            return productos;
        }
    }
}
