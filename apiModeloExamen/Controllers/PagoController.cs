using apiModeloExamen.Repositories.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace apiModeloExamen.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PagoController : ControllerBase
    {
        private readonly IPagoRepository _repo;

        public PagoController(IPagoRepository repo)
        {
            _repo = repo;
        }

        // ================================
        // CLIENTE
        // ================================

        [Tags("Cliente - Pagos")]
        [HttpPost("registrar")]
        public async Task<IActionResult> RegistrarPago(int idOrden, decimal monto, string metodo)
        {
            await _repo.RegistrarPagoAsync(idOrden, monto, metodo);
            return Ok("Pago registrado correctamente");
        }

        [Tags("Cliente - Pagos")]
        [HttpGet("usuario/{idUsuario}/historial")]
        public async Task<IActionResult> HistorialCompras(int idUsuario)
        {
            var historial = await _repo.ListarPorUsuarioAsync(idUsuario);
            return Ok(historial);
        }

        // ================================
        // ADMINISTRADOR
        // ================================

        [Tags("Administrador - Pagos")]
        [HttpGet]
        public async Task<IActionResult> Listar()
        {
            var pagos = await _repo.ListarAsync();
            return Ok(pagos);
        }

        [Tags("Administrador - Pagos")]
        [HttpGet("detallado")]
        public async Task<IActionResult> ListarDetallado()
        {
            var data = await _repo.ListarDetalladoAsync();
            return Ok(data);
        }
    }
}
