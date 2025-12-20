using apiModeloExamen.Contracts.Entities;

namespace apiModeloExamen.Repositories.Interfaces
{
    public interface IProductoRepository
    {
        Task<IEnumerable<Producto>> ListarAsync();
        Task<IEnumerable<Producto>> ListarPorCategoriaAsync(int idCategoria);
        Task<int> InsertarAsync(Producto producto);
        Task EditarAsync(Producto producto);
    }
}
