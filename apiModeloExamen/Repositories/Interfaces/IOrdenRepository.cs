using apiModeloExamen.Contracts.Dtos;
using apiModeloExamen.Contracts.Entities;

namespace apiModeloExamen.Repositories.Interfaces
{
    public interface IOrdenRepository
    {
        Task GenerarOrdenAsync(int idUsuario);
        Task<IEnumerable<Orden>> ListarPorUsuarioAsync(int idUsuario);
        Task<List<PagoDetalladoDto>> ObtenerDetalleOrdenAsync(int idOrden);
    }
}
