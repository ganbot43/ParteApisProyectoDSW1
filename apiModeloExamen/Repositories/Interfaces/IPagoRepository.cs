using apiModeloExamen.Contracts.Dtos;
using apiModeloExamen.Contracts.Entities;

namespace apiModeloExamen.Repositories.Interfaces
{
    public interface IPagoRepository
    {
        Task RegistrarPagoAsync(int idOrden, decimal monto, string metodo);

        //parte admin
        Task<IEnumerable<Pago>> ListarAsync();
        Task<IEnumerable<PagoDetalladoDto>> ListarDetalladoAsync();

        // parte cliente
        Task<IEnumerable<PagoDetalladoUsuarioDto>> ListarPorUsuarioAsync(int idUsuario);
    }
}
