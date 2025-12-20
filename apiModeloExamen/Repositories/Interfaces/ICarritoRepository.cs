using apiModeloExamen.Contracts.Entities;

namespace apiModeloExamen.Repositories.Interfaces
{
    public interface ICarritoRepository
    {
        Task<int> ObtenerCarritoActivoAsync(int idUsuario);
        Task AgregarProductoAsync(int idCarrito, int idProducto, int cantidad);
        Task<IEnumerable<CarritoDetalle>> VerCarritoAsync(int idCarrito);
    }
}
